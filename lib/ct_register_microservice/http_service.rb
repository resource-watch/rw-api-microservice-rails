require 'httparty'
require 'ct_register_microservice/http_service/response'
require 'ct_register_microservice/http_service/endpoint'

module CtRegisterMicroservice
  module HTTPService
    class << self
    end

    def self.make_request(options, credentials = {})
      http_method = options.http_method&.to_sym || :get
      url = CtRegisterMicroservice.config.ct_url
      headers = options.headers || {}
      headers['Content-Type'] = 'application/json' if options.http_method == 'post' || options.http_method == 'put'
      endpoint = Endpoint.new(options, credentials).get

      case http_method
      when :get
        response = HTTParty.get(url+endpoint, headers: headers)
      when :delete
        response = HTTParty.delete(url+endpoint, headers: headers)
      when :post
        response = HTTParty.post(url+endpoint, {
          headers: headers,
          body: options.body.to_json
        })
      when :put
        response = HTTParty.put(url+endpoint, {
          headers: headers,
          body: options.body.to_json
        })
      when :patch
        response = HTTParty.patch(url+endpoint, {
          headers: headers,
          body: options.body.to_json
        })
      end

      CtRegisterMicroservice::HTTPService::Response.new(response.code.to_i, response.body, response.headers)
    end
  end
end
