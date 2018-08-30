require 'rails_helper'

module CtRegisterMicroservice
  RSpec.describe InfoController, type: :controller do
    before(:all) do
      CtRegisterMicroservice.configure do |config|
        config.ct_url = 'http://control-tower.com'
        config.url = 'myurl.com'
        config.ct_token = 'token'
        config.swagger = __dir__ + '/../../mocks/mock-swagger.json'
        config.name = 'Test microservice'
        config.dry_run = false
      end
    end

    routes { CtRegisterMicroservice::Engine.routes }

    describe 'Get info' do
      it 'Info responds 200 if everything is ok (happy case)' do
        get :info
        expect(response.status).to eq 200
        expect(response.body).to eq File.read(CtRegisterMicroservice.config.swagger).gsub(/\s+/, "")
      end

      it 'Info responds 500 if file is not accessible' do
        CtRegisterMicroservice.config.swagger = 'file-that-doesnt-exit.yml'

        get :info
        expect(response.status).to eq 500
      end

      it 'Info responds 500 if file is not defined' do
        CtRegisterMicroservice.config.swagger = nil

        get :info
        expect(response.status).to eq 500
      end
    end

    describe 'Ping' do
      it 'Ping responds 200' do
        get :ping
        expect(response.status).to eq 200
        expect(response.body).to eq '{"success":true,"message":"Test microservice"}'

      end
    end

    after(:all) do
      CtRegisterMicroservice.config = nil
    end

  end
end
