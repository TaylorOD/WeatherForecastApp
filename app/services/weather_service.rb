require 'httparty'
require 'redis'
require 'json'

# WeatherService is responsible for fetching weather forecast data
# either from a cache (Redis) or from an external weather API.
class WeatherService
  # Initializes the WeatherService with address details and sets up Redis.
  #
  # @param address [String] the street address
  # @param zip_code [String] the zip code
  # @param state [String] the state
  # @param country [String] the country
  def initialize(address, zip_code, state, country)
    @address = address
    @zip_code = zip_code
    @state = state
    @country = country
    @redis = Redis.new
  end

  # Fetches the weather forecast. First, it checks the cache (Redis).
  # If the data is not cached, it fetches from the external API and caches it.
  #
  # @return [Hash] the weather forecast data or an error message
  def get_forecast
    zip_code = extract_zip_code
    return { error: 'Invalid address' } unless zip_code

    # Check if the forecast is cached
    cached_forecast = @redis.get(zip_code)

    if cached_forecast
      # Return cached forecast data
      forecast_data = JSON.parse(cached_forecast, symbolize_names: true)
      { data: forecast_data, cached: true }
    else
      # Fetch forecast from the external API
      api_key = ENV['WEATHER_API_KEY']
      url = "https://api.weatherapi.com/v1/forecast.json?key=#{api_key}&q=#{zip_code}&days=3"
      response = HTTParty.get(url)

      if response.success?
        # Parse and cache the forecast data
        forecast_data = parse_response(response)
        @redis.setex(zip_code, 30 * 60, forecast_data.to_json) # Cache for 30 minutes
        { data: forecast_data, cached: false }
      else
        { error: 'Could not retrieve forecast data' }
      end
    end
  end

  private

  # Extracts the zip code from the address details.
  #
  # @return [String] the zip code
  def extract_zip_code
    @zip_code
  end

  # Parses the API response to extract relevant forecast data.
  #
  # @param response [HTTParty::Response] the API response
  # @return [Hash] the parsed forecast data
  def parse_response(response)
    forecast_days = response['forecast']['forecastday'].map do |day|
      {
        date: day['date'],
        high_temp: day['day']['maxtemp_f'],
        low_temp: day['day']['mintemp_f'],
        condition: day['day']['condition']['text']
      }
    end

    {
      current_temp: response['current']['temp_f'],
      high_temp: forecast_days.first[:high_temp],
      low_temp: forecast_days.first[:low_temp],
      extended_forecast: forecast_days
    }
  rescue StandardError => e
    { error: "Error parsing response: #{e.message}" }
  end
end
