require 'rails_helper'

RSpec.describe RwApiMicroservice::APIError do
  it "is a RwApiMicroservice::RwApiMicroserviceError" do
    expect(RwApiMicroservice::APIError.new(nil, nil)).to be_a(RwApiMicroservice::RwApiMicroserviceError)
  end

  [:rw_error_type, :rw_error_code, :rw_error_subcode, :rw_error_message, :rw_error_user_msg, :rw_error_user_title, :http_status, :response_body].each do |accessor|
    it "has an accessor for #{accessor}" do
      expect(RwApiMicroservice::APIError.instance_methods.map(&:to_sym)).to include(accessor)
      expect(RwApiMicroservice::APIError.instance_methods.map(&:to_sym)).to include(:"#{accessor}=")
    end
  end

  it "sets http_status to the provided status" do
    error_response = '{ "error": {"type": "foo", "other_details": "bar"} }'
    expect(RwApiMicroservice::APIError.new(400, error_response).response_body).to eq(error_response)
  end

  it "sets response_body to the provided response body" do
    expect(RwApiMicroservice::APIError.new(400, '').http_status).to eq(400)
  end

  context "with an error_info string" do
    it "sets the error message \"error_info [HTTP http_status]\"" do
      error_info = "RW API is down."
      error = RwApiMicroservice::APIError.new(400, '', error_info)
      expect(error.message).to eq("RW API is down.")
    end
  end
end

RSpec.describe RwApiMicroservice::RwApiMicroserviceError do
  it "is a StandardError" do
     expect(RwApiMicroservice::RwApiMicroserviceError.new).to be_a(StandardError)
  end
end

RSpec.describe RwApiMicroservice::BadCTResponse do
  it "is a RwApiMicroservice::APIError" do
     expect(RwApiMicroservice::BadCTResponse.new(nil, nil)).to be_a(RwApiMicroservice::APIError)
  end
end

RSpec.describe RwApiMicroservice::OAuthTokenRequestError do
  it "is a RwApiMicroservice::APIError" do
     expect(RwApiMicroservice::OAuthTokenRequestError.new(nil, nil)).to be_a(RwApiMicroservice::APIError)
  end
end

RSpec.describe RwApiMicroservice::ServerError do
  it "is a RwApiMicroservice::APIError" do
     expect(RwApiMicroservice::ServerError.new(nil, nil)).to be_a(RwApiMicroservice::APIError)
  end
end

RSpec.describe RwApiMicroservice::ClientError do
  it "is a RwApiMicroservice::APIError" do
     expect(RwApiMicroservice::ClientError.new(nil, nil)).to be_a(RwApiMicroservice::APIError)
  end
end

RSpec.describe RwApiMicroservice::AuthenticationError do
  it "is a RwApiMicroservice::ClientError" do
     expect(RwApiMicroservice::AuthenticationError.new(nil, nil)).to be_a(RwApiMicroservice::ClientError)
  end
end
