require 'rails_helper'

RSpec.describe "RwApiMicroservice::API initialization with config" do
  before do
    RwApiMicroservice.config = nil
  end

  it "Initializing a service without Gateway URL throws an error" do
    expect { RwApiMicroservice::Gateway.new() }.to raise_error(
                                                               RwApiMicroservice::MissingConfigError,
                                                               'Could not register microservice - No Gateway URL defined'
                                                             )
  end
  it "Initializing a service without Microservice Token throws an error" do
    RwApiMicroservice.configure do |config|
      config.gateway_url = 'rw-api.org'
    end

    expect { RwApiMicroservice::Gateway.new() }.to raise_error(
                                                               RwApiMicroservice::MissingConfigError,
                                                               'Could not register microservice - No Microservice Token found'
                                                             )
  end

  it "Initializing a service with all params create an API class" do
    RwApiMicroservice.configure do |config|
      config.gateway_url = 'rw-api.org'
      config.microservice_token = 'token'
    end

    expect { RwApiMicroservice::Gateway.new() }.to_not raise_error()
  end

  after(:all) do
    RwApiMicroservice.config = nil
  end
end
