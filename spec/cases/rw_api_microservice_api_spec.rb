require 'rails_helper'

RSpec.describe "RwApiMicroservice::API" do
  before(:all) do
    RwApiMicroservice.configure do |config|
      config.gateway_url = 'http://rw-api.org'
      config.microservice_token = 'token'
    end

    @service = RwApiMicroservice::Gateway.new()
  end

  it "Handles a successful GET request" do
    request_url = "http://rw-api.org/api/v1/other-microservice"
    request_content = {
      headers: {
        authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 200, body: '{}', headers: {}).times(1)

    @service.microservice_request('/api/v1/other-microservice', :get)

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end

  it "Handles a server error GET request" do
    request_url = "http://rw-api.org/api/v1/other-microservice"
    request_content = {
      headers: {
        authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 500, body: '{"errors":[{"status":500,"detail":"Server error processing a request"}]}', headers: {}).times(1)

    expect { @service.microservice_request('/api/v1/other-microservice', :get) }.to raise_error(RwApiMicroservice::ServerError, 'Server error processing a request')

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end

  it "Handles a no token error GET request" do
    request_url = "http://rw-api.org/api/v1/other-microservice"
    request_content = {
      headers: {
        authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 401, body: '{"errors":[{"status":401,"detail":"Not authenticated"}]}', headers: {}).times(1)

    expect { @service.microservice_request('/api/v1/other-microservice', :get) }.to raise_error(RwApiMicroservice::NoTokenError, 'Not authenticated')

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end

  after(:all) do
    RwApiMicroservice.config = nil
  end
end
