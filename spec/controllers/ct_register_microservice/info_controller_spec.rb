require 'rails_helper'

module CtRegisterMicroservice
  RSpec.describe InfoController, type: :controller do
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
    end

    describe 'Ping' do
      it 'Ping responds 200' do
        get :ping
        expect(response.status).to eq 200
      end
    end

  end
end
