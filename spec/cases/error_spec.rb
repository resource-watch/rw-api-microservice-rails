require 'rails_helper'

RSpec.describe CtRegisterMicroservice::APIError do
  it "is a CtRegisterMicroservice::CtRegisterMicroserviceError" do
    expect(CtRegisterMicroservice::APIError.new(nil, nil)).to be_a(CtRegisterMicroservice::CtRegisterMicroserviceError)
  end

  [:ct_error_type, :ct_error_code, :ct_error_subcode, :ct_error_message, :ct_error_user_msg, :ct_error_user_title, :http_status, :response_body].each do |accessor|
    it "has an accessor for #{accessor}" do
      expect(CtRegisterMicroservice::APIError.instance_methods.map(&:to_sym)).to include(accessor)
      expect(CtRegisterMicroservice::APIError.instance_methods.map(&:to_sym)).to include(:"#{accessor}=")
    end
  end

  it "sets http_status to the provided status" do
    error_response = '{ "error": {"type": "foo", "other_details": "bar"} }'
    expect(CtRegisterMicroservice::APIError.new(400, error_response).response_body).to eq(error_response)
  end

  it "sets response_body to the provided response body" do
    expect(CtRegisterMicroservice::APIError.new(400, '').http_status).to eq(400)
  end

  context "with an error_info string" do
    it "sets the error message \"error_info [HTTP http_status]\"" do
      error_info = "Control Tower is down."
      error = CtRegisterMicroservice::APIError.new(400, '', error_info)
      expect(error.message).to eq("Control Tower is down.")
    end
  end
end

RSpec.describe CtRegisterMicroservice::CtRegisterMicroserviceError do
  it "is a StandardError" do
     expect(CtRegisterMicroservice::CtRegisterMicroserviceError.new).to be_a(StandardError)
  end
end

RSpec.describe CtRegisterMicroservice::BadCTResponse do
  it "is a CtRegisterMicroservice::APIError" do
     expect(CtRegisterMicroservice::BadCTResponse.new(nil, nil)).to be_a(CtRegisterMicroservice::APIError)
  end
end

RSpec.describe CtRegisterMicroservice::OAuthTokenRequestError do
  it "is a CtRegisterMicroservice::APIError" do
     expect(CtRegisterMicroservice::OAuthTokenRequestError.new(nil, nil)).to be_a(CtRegisterMicroservice::APIError)
  end
end

RSpec.describe CtRegisterMicroservice::ServerError do
  it "is a CtRegisterMicroservice::APIError" do
     expect(CtRegisterMicroservice::ServerError.new(nil, nil)).to be_a(CtRegisterMicroservice::APIError)
  end
end

RSpec.describe CtRegisterMicroservice::ClientError do
  it "is a CtRegisterMicroservice::APIError" do
     expect(CtRegisterMicroservice::ClientError.new(nil, nil)).to be_a(CtRegisterMicroservice::APIError)
  end
end

RSpec.describe CtRegisterMicroservice::AuthenticationError do
  it "is a CtRegisterMicroservice::ClientError" do
     expect(CtRegisterMicroservice::AuthenticationError.new(nil, nil)).to be_a(CtRegisterMicroservice::ClientError)
  end
end
