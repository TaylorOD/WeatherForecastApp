require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  let(:address) { '1510 Van Buren Street' }
  let(:zip_code) { '59802' }
  let(:state) { 'Montana' }
  let(:country) { 'United States' }
  let(:weather_service) { WeatherService.new(address, zip_code, state, country) }

  describe '#get_forecast' do
    context 'when the forecast is cached' do
      it 'returns the cached forecast' do
        cached_data = {
          current_temp: 36.0,
          high_temp: 43.7,
          low_temp: 27.1,
          extended_forecast: [
            { date: '2024-11-04', high_temp: 43.7, low_temp: 27.1, condition: 'Overcast' },
            { date: '2024-11-05', high_temp: 35.4, low_temp: 27.5, condition: 'Moderate snow' },
            { date: '2024-11-06', high_temp: 40.1, low_temp: 24.6, condition: 'Cloudy' }
          ]
        }.to_json

        allow_any_instance_of(Redis).to receive(:get).with(zip_code).and_return(cached_data)

        result = weather_service.get_forecast

        expect(result[:data]).to eq(JSON.parse(cached_data, symbolize_names: true))
        expect(result[:cached]).to be true
      end
    end

    context 'when the API request fails' do
      it 'returns an error' do
        allow_any_instance_of(Redis).to receive(:get).with(zip_code).and_return(nil)
        allow(HTTParty).to receive(:get).and_return(double(success?: false))

        result = weather_service.get_forecast

        expect(result[:error]).to eq('Could not retrieve forecast data')
      end
    end
  end
end
