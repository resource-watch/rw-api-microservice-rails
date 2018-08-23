require 'spec_helper'

RSpec.describe "CtRegisterMicroservice::API" do
  before(:each) do
    @service = CtRegisterMicroservice::API.new('http://control-tower.com',  'api-token-value')
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
        Authorization: 'Bearer api-token-value'
      }
    }

    stub_request(:get, request_url).with(request_content).to_return(status: 200, body: "", headers: {})

    @service.microservice_request('api/v1/other-microservice', :get)

    expect(a_request(:get, request_url).with(request_content)).to have_been_made.once
  end
end



RSpec.describe "CtRegisterMicroservice::API dry run requests" do
  before(:each) do
    CtRegisterMicroservice.config.dry_run = true
    @service = CtRegisterMicroservice::API.new('http://control-tower.com',  'api-token-value')
  end
  it "dry runs query requests" do
    expect(CtRegisterMicroservice).to_not receive(:make_request)
    @service.send_query('anything')
  end
end

