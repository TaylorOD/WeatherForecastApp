require 'rails_helper'

RSpec.describe "DadJokes", type: :request do
  describe "GET /index" do
    let(:dad_joke_service) { instance_double('DadJokeService') }

    before do
      allow(DadJokeService).to receive(:new).and_return(dad_joke_service)
    end

    context 'when the joke is successfully retrieved' do
      let(:joke_data) { 'Why don’t skeletons fight each other? They don’t have the guts.' }

      before do
        allow(dad_joke_service).to receive(:get_joke).and_return({ data: joke_data })
        get dad_joke_index_path
      end

      it 'assigns @joke_data' do
        expect(assigns(:joke_data)).to eq(joke_data)
      end

      it 'does not set a flash error' do
        expect(flash[:error]).to be_nil
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when there is an error retrieving the joke' do
      let(:error_message) { 'Could not retrieve joke data' }

      before do
        allow(dad_joke_service).to receive(:get_joke).and_return({ error: error_message })
        get dad_joke_index_path
      end

      it 'sets a flash error' do
        expect(flash[:error]).to eq(error_message)
      end

      it 'does not assign @joke_data' do
        expect(assigns(:joke_data)).to be_nil
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end
