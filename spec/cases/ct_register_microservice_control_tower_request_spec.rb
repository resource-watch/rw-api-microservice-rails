require 'rails_helper'

RSpec.describe "CtRegisterMicroservice::ControlTower request" do
  before(:all) do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'http://control-tower.com'
      config.url = 'http://my-microservice-url.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
      config.name = 'Test'
    end

    @service = CtRegisterMicroservice::ControlTower.new()
  end
  it "Requests with microservice down throws an exception" do
    request_url = "http://control-tower.com/test/microservice"
    request_content = {
      body: {}
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 404, body: '{"errors":[{"status":404,"detail":"Endpoint not found"}]}').times(1)

    expect { @service.microservice_request('/test/microservice', :get) }.to raise_error(CtRegisterMicroservice::NotFoundError, 'Endpoint not found')
  end

  it "GET requests to microservice succeed (happy case)" do
    @service = CtRegisterMicroservice::ControlTower.new()

    request_url = "http://control-tower.com/test/microservice-get"

    stub_request(:get, request_url).to_return(status: 200, body: "", headers: {}).times(1)

    @service.microservice_request('/test/microservice-get', :get)

    expect(a_request(:get, request_url)).to have_been_made.once
  end

  it "POST requests to microservice succeed (happy case)" do
    @service = CtRegisterMicroservice::ControlTower.new()

    request_url = "http://control-tower.com/test/microservice-get"
    request_content = {
      body: {
        foo: 'bar'
      },
      headers: {
        'Authentication' => 'token'
      }
    }

    response_body = {object: {param1: 'value1', param2: 2}}

    stub_request(:post, request_url).with(request_content).to_return(status: 200, body: response_body.to_json, headers: {}).times(1)

    response = @service.microservice_request('/test/microservice-get', :post, {header1: 'header 1 value'}, {foo: 'bar'})
    expect(JSON.parse response).to eq(response_body.deep_stringify_keys)

    expect(a_request(:post, request_url).with(request_content)).to have_been_made.once
  end

  it "PUT requests to microservice succeed (happy case)" do
    @service = CtRegisterMicroservice::ControlTower.new()

    request_url = "http://control-tower.com/test/microservice-get"
    request_content = {
      body: {
        foo: 'bar'
      },
      headers: {
        'Authentication' => 'token'
      }
    }

    response_body = {object: {param1: 'value1', param2: 2}}

    stub_request(:put, request_url).with(request_content).to_return(status: 200, body: response_body.to_json, headers: {}).times(1)

    response = @service.microservice_request('/test/microservice-get', :put, {header1: 'header 1 value'}, {foo: 'bar'})
    expect(JSON.parse response).to eq(response_body.deep_stringify_keys)

    expect(a_request(:put, request_url).with(request_content)).to have_been_made.once
  end

  it "PATCH requests to microservice succeed (happy case)" do
    @service = CtRegisterMicroservice::ControlTower.new()

    request_url = "http://control-tower.com/test/microservice-get"
    request_content = {
      body: {
        foo: 'bar'
      },
      headers: {
        'Authentication' => 'token'
      }
    }

    response_body = {object: {param1: 'value1', param2: 2}}

    stub_request(:patch, request_url).with(request_content).to_return(status: 200, body: response_body.to_json, headers: {}).times(1)

    response = @service.microservice_request('/test/microservice-get', :patch, {header1: 'header 1 value'}, {foo: 'bar'})
    expect(JSON.parse response).to eq(response_body.deep_stringify_keys)

    expect(a_request(:patch, request_url).with(request_content)).to have_been_made.once
  end

  it "DELETE requests to microservice succeed (happy case)" do
    @service = CtRegisterMicroservice::ControlTower.new()

    request_url = "http://control-tower.com/test/microservice-get"
    request_content = {
      headers: {
        'Authentication' => 'token'
      }
    }

    response_body = {object: {param1: 'value1', param2: 2}}

    stub_request(:delete, request_url).with(request_content).to_return(status: 200, body: response_body.to_json, headers: {}).times(1)

    @service.microservice_request('/test/microservice-get', :delete, {header1: 'header 1 value'}, {foo: 'bar'})

    expect(a_request(:delete, request_url).with(request_content)).to have_been_made.once
  end

  after(:all) do
    CtRegisterMicroservice.config = nil
  end
end
