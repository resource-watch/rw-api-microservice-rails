require 'rails_helper'
require 'ct_register_microservice'

RSpec.describe "CtRegisterMicroservice::API initialization with config" do
  before do
    CtRegisterMicroservice.config = nil
  end

  it "Initializing a service without CT URL throws an error" do
    expect { CtRegisterMicroservice::ControlTower.new() }.to raise_error(
                                                               CtRegisterMicroservice::MissingConfigError,
                                                               'Could not register microservice - No Control Tower URL defined'
                                                             )
  end
  it "Initializing a service without CT token throws an error" do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
    end

    expect { CtRegisterMicroservice::ControlTower.new() }.to raise_error(
                                                               CtRegisterMicroservice::MissingConfigError,
                                                               'Could not register microservice - No self URL defined'
                                                             )
  end
  it "Initializing a service without CT token throws an error" do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
      config.url = 'myurl.com'
    end

    expect { CtRegisterMicroservice::ControlTower.new() }.to raise_error(
                                                               CtRegisterMicroservice::MissingConfigError,
                                                               'Could not register microservice - No Control Tower auth token found'
                                                             )
  end
  it "Initializing a service without a swagger path throws an error" do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
      config.url = 'myurl.com'
      config.ct_token = 'token'
    end

    expect { CtRegisterMicroservice::ControlTower.new() }.to raise_error(
                                                               CtRegisterMicroservice::MissingConfigError,
                                                               'Could not register microservice - No swagger file defined'
                                                             )
  end
  it "Initializing a service with an invalid swagger path throws an error" do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
      config.url = 'myurl.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/file-that-doesnt-exit.txt'
    end

    expect { CtRegisterMicroservice::ControlTower.new() }.to raise_error(
                                                               CtRegisterMicroservice::MissingConfigError,
                                                               'Could not register microservice - Swagger file path ' + File.absolute_path(__dir__ + '/file-that-doesnt-exit.txt') + 'does not match a file'
                                                             )
  end
  it "Initializing a service without a name throws an error" do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
      config.url = 'myurl.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
    end

    expect { CtRegisterMicroservice::ControlTower.new() }.to raise_error(
                                                               CtRegisterMicroservice::MissingConfigError,
                                                               'Could not register microservice - Microservice name not defined'
                                                             )
  end

  it "Initializing a service with all params create an API class" do
    CtRegisterMicroservice.configure do |config|
      config.ct_url = 'cturl.com'
      config.url = 'myurl.com'
      config.ct_token = 'token'
      config.swagger = __dir__ + '/../mocks/mock-swagger.json'
      config.name = 'Test'
    end

    expect { CtRegisterMicroservice::ControlTower.new() }.to_not raise_error()
  end

  after(:all) do
    CtRegisterMicroservice.config = nil
  end
end
