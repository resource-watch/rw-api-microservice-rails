require 'rails_helper'
load 'Rakefile'

describe 'CtRegisterMicroservice::Rake' do
  before() do
    Rake.application = Rake::Application.new
    Rails.application.load_tasks
  end

  describe 'test rake register' do
    it  'Registering with rake tasks and no config should throw error' do
      CtRegisterMicroservice.config = nil

      expect { Rake::Task['ct_register_microservice:register'].invoke }.to raise_error(
                                                                      CtRegisterMicroservice::MissingConfigError,
                                                                      'Could not register microservice - No Control Tower URL defined'
                                                                    )
    end

    it 'Registering with rake tasks full config should call Control Tower endpoint' do
      CtRegisterMicroservice.configure do |config|
        config.ct_url = 'http://control-tower.com'
        config.url = 'http://my-microservice-url.com'
        config.ct_token = 'token'
        config.swagger = __dir__ + '/../mocks/mock-swagger.json'
        config.name = 'Test'
      end

      request_url = "http://control-tower.com/api/v1/microservice"
      request_content = {
        body: {
          name: 'Test',
          url: 'http://my-microservice-url.com',
          active: true
        }
      }

      stub_request(:post, request_url).with(request_content).to_return(status: 200, body: "", headers: {}).times(1)

      expect { Rake::Task['ct_register_microservice:register'].invoke }.to_not raise_error

      expect(a_request(:post, request_url).with(request_content)).to have_been_made.once

    end
  end
end
