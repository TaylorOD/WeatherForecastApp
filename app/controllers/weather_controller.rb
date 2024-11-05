class WeatherController < ApplicationController
  # The index action handles the weather forecast request.
  # It checks if all required address parameters are present,
  # then uses the WeatherService to fetch the forecast data.
  def index
    if params[:address].present? && params[:zip_code].present? && params[:state].present? && params[:country].present?
      # Initialize the WeatherService with the provided address details
      weather_service = WeatherService.new(params[:address], params[:zip_code], params[:state], params[:country])
      result = weather_service.get_forecast

      if result[:error]
        # If there is an error, set the flash error message and clear forecast data
        flash[:error] = result[:error]
        @forecast_data = nil
        @from_cache = false
      else
        # If successful, set the forecast data and cache status
        @forecast_data = result[:data]
        @from_cache = result[:cached]
      end
    else
      # If any address field is missing, set the flash error message
      flash[:error] = 'All address fields are required'
    end
  end
end
