require 'rails_helper'

RSpec.describe "CtRegisterMicroservice::API" do
  before(:all) do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'http://control-tower.com'
      config.url = 'myurl.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
      config.name = 'Test'
    end

    @service = CtRegisterMicroservice::ControlTower.new()
  end

  it "Handles a successful GET request" do
    request_url = "http://control-tower.com/api/v1/other-microservice"
    request_content = {
      headers: {
        Authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 200, body: '{}', headers: {}).times(1)

    @service.microservice_request('/api/v1/other-microservice', :get)

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end

  it "Handles a server error GET request" do
    request_url = "http://control-tower.com/api/v1/other-microservice"
    request_content = {
      headers: {
        Authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 500, body: '{"errors":[{"status":500,"detail":"Server error processing a request"}]}', headers: {}).times(1)

    expect { @service.microservice_request('/api/v1/other-microservice', :get) }.to raise_error(CtRegisterMicroservice::ServerError, 'Server error processing a request')

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end

  it "Handles a no token error GET request" do
    request_url = "http://control-tower.com/api/v1/other-microservice"
    request_content = {
      headers: {
        Authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 401, body: '{"errors":[{"status":401,"detail":"Not authenticated"}]}', headers: {}).times(1)

    expect { @service.microservice_request('/api/v1/other-microservice', :get) }.to raise_error(CtRegisterMicroservice::NoTokenError, 'Not authenticated')

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end

  after(:all) do
    CtRegisterMicroservice.config = nil
  end
end
