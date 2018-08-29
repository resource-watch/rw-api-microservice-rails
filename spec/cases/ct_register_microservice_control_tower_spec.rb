require 'rails_helper'

RSpec.describe "CtRegisterMicroservice::ControlTower" do
  before() do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'http://control-tower.com'
      config.url = 'http://my-microservice-url.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
      config.name = 'Test'
      config.dry_run = false
    end
  end
  it "registration with Control Tower down throws an exception" do
    request_url = "http://control-tower.com/api/v1/microservice"
    request_content = {
      body: {
        name: 'Test',
        url: 'http://my-microservice-url.com',
        active: true
      }
    }

    stub_request(:post, request_url).with(request_content).to_return(status: [404, 'Not found']).times(1)

    @service = CtRegisterMicroservice::ControlTower.new()

    expect { @service.register_service() }.to raise_error(CtRegisterMicroservice::CtRegisterMicroserviceError, 'Control Tower not reachable at http://control-tower.com')
  end

  it "registers services in Control Tower" do
    @service = CtRegisterMicroservice::ControlTower.new()

    request_url = "http://control-tower.com/api/v1/microservice"
    request_content = {
      body: {
        name: 'Test',
        url: 'http://my-microservice-url.com',
        active: true
      }
    }

    stub_request(:post, request_url).with(request_content).to_return(status: 200, body: "", headers: {}).times(1)

    @service.register_service()

    expect(a_request(:post, request_url).with(request_content)).to have_been_made.once
  end
end
