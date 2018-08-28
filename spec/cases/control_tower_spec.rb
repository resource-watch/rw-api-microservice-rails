require 'spec_helper'

RSpec.describe "CtRegisterMicroservice::API" do
  before(:each) do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'http://control-tower.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
      config.name = 'Test'
    end


    @service = CtRegisterMicroservice::ControlTower.new()
  end
  it "makes query requests" do
    expect(CtRegisterMicroservice).to receive(:make_request).and_return(CtRegisterMicroservice::HTTPService::Response.new(200, "", ""))
    @service.send_query('anything')
  end
  it "makes post query requests" do
    expect(CtRegisterMicroservice).to receive(:make_request).and_return(CtRegisterMicroservice::HTTPService::Response.new(200, "", ""))
    @service.post_query('anything')
  end

  it "registers services in Control Tower" do
    request_url = "http://control-tower.com/api/v1/microservice"
    request_content = {
      body: {
        name: 'Microservice name',
        url: 'http://my-microservice-url.com',
        active: true
      }
    }

    stub_request(:post, request_url).with(request_content).to_return(status: 200, body: "", headers: {})

    @service.register_service('Microservice name', 'http://my-microservice-url.com', true)

    expect(a_request(:post, request_url).with(request_content)).to have_been_made.once
  end

  it "makes a GET request to a different services within Control Tower" do
    request_url = "http://control-tower.com/api/v1/other-microservice"
    request_content = {
      headers: {
        Authorization: 'Bearer token'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 200, body: "", headers: {})

    @service.microservice_request('api/v1/other-microservice', :get)

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end
end



RSpec.describe "CtRegisterMicroservice::API dry run requests" do
  before(:each) do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
      config.name = 'Test'
      config.dry_run = true
    end

    @service = CtRegisterMicroservice::ControlTower.new()
  end
  it "dry runs query requests" do
    expect(CtRegisterMicroservice).to_not receive(:make_request)
    @service.send_query('anything')
  end
end

