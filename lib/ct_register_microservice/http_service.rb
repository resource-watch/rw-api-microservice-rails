require 'faraday'
require 'ct_register_microservice/http_service/response'
require 'ct_register_microservice/http_service/endpoint'
module CtRegisterMicroservice
  module HTTPService
    class << self
    end

    def self.make_request(options, credentials = {})
      http_method = options.http_method&.to_sym || :get
      ct_url = credentials["ct_url"]
      endpoint = Endpoint.new(options, credentials).get
      con = Faraday.new(:url => ct_url) do |faraday|
        faraday.request :multipart
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
      response = con.send(http_method) do |req|
        req.url "#{endpoint}"
        req.headers = options.headers || {}
        req.headers['Content-Type'] = 'application/json' if options.http_method == 'post' || options.http_method == 'put'
        req.body = options.body.to_json if options.http_method == 'post' || options.http_method == 'put'
      end
      CtRegisterMicroservice::HTTPService::Response.new(response.status.to_i, response.body, response.headers)
    end
  end
end
