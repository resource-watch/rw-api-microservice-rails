require 'rails_helper'
require 'ct_register_microservice'

RSpec.describe "CtRegisterMicroservice::API initialization" do
  it "Initializing a service without CT URL throws an error" do
    expect{CtRegisterMicroservice::API.new()}.to raise_error(CtRegisterMicroservice::MissingCTURLError)
  end
  it "Initializing a service without CT token throws an error" do
    expect{CtRegisterMicroservice::API.new('cturl.com')}.to raise_error(CtRegisterMicroservice::MissingCTTokenError)
  end

  it "Initializing a service with CT URL and token create an API class" do
    expect{CtRegisterMicroservice::API.new('cturl.com', 'token')}.to_not raise_error()
  end
end
