require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe 'GET #index' do
    let(:address) { '1510 Van Buren Street' }
    let(:zip_code) { '59802' }
    let(:state) { 'Montana' }
    let(:country) { 'United States' }

    context 'when all address fields are provided' do
      before do
        allow_any_instance_of(WeatherService).to receive(:get_forecast).and_return(result)
        get :index, params: { address: address, zip_code: zip_code, state: state, country: country }
      end

      context 'when the forecast is successfully retrieved' do
        let(:result) do
          {
            data: {
              current_temp: 64.9,
              high_temp: 65.5,
              low_temp: 59.7,
              extended_forecast: [
                { date: '2024-11-04', high_temp: 65.5, low_temp: 59.7, condition: 'Moderate rain' },
                { date: '2024-11-05', high_temp: 64.2, low_temp: 55.0, condition: 'Patchy rain nearby' },
                { date: '2024-11-06', high_temp: 51.4, low_temp: 43.2, condition: 'Cloudy' }
              ]
            },
            cached: false
          }
        end

        it 'assigns @forecast_data' do
          expect(assigns(:forecast_data)).to eq(result[:data])
        end

        it 'assigns @from_cache' do
          expect(assigns(:from_cache)).to eq(result[:cached])
        end

        it 'does not set a flash error' do
          expect(flash[:error]).to be_nil
        end
      end

      context 'when there is an error retrieving the forecast' do
        let(:result) { { error: 'Could not retrieve forecast data' } }

        it 'sets a flash error' do
          expect(flash[:error]).to eq(result[:error])
        end

        it 'does not assign @forecast_data' do
          expect(assigns(:forecast_data)).to be_nil
        end

        it 'assigns @from_cache as false' do
          expect(assigns(:from_cache)).to be false
        end
      end
    end

    context 'when not all address fields are provided' do
      before do
        get :index, params: { address: address, zip_code: zip_code, state: state }
      end

      it 'sets a flash error' do
        expect(flash[:error]).to eq('All address fields are required')
      end

      it 'does not assign @forecast_data' do
        expect(assigns(:forecast_data)).to be_nil
      end

      it 'assigns @from_cache as false' do
        expect(assigns(:from_cache)).to be_nil
      end
    end
  end
end
