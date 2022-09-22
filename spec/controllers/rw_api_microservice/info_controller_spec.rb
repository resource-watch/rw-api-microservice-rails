require 'rails_helper'

module RwApiMicroservice
  RSpec.describe InfoController, type: :controller do
    before(:all) do
      RwApiMicroservice.configure do |config|
        config.gateway_url = 'http://rw-api.org'
        config.microservice_token = 'token'
      end
    end

    routes { RwApiMicroservice::Engine.routes }

    describe 'Ping' do
      it 'Ping responds 200' do
        get :ping
        expect(response.status).to eq 200
        expect(response.body).to eq '{"success":true}'

      end
    end

    after(:all) do
      RwApiMicroservice.config = nil
    end

  end
end
