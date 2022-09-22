require 'rw_api_microservice/errors'

module RwApiMicroservice
  class Gateway
    def initialize
      if RwApiMicroservice.config.gateway_url.nil?
        raise MissingConfigError, 'Could not register microservice - No Gateway URL defined'
      end
      if RwApiMicroservice.config.microservice_token.nil?
        raise MissingConfigError, 'Could not register microservice - No Microservice Token found'
      end

      @options = OpenStruct.new
    end

    attr_reader :credentials, :options, :response, :gateway_url

    # TODO: make sure it works as intended, add unit tests
    def microservice_request(uri, method, headers = {}, body = nil)
      options.http_method = method
      options.endpoint = uri
      options.headers = headers
      options.headers['authorization'] = 'Bearer '+RwApiMicroservice.config.microservice_token
      options.body = body
      result = make_call(options)
      result
    end

    def initialize_options
      @options = OpenStruct.new
    end

    private

    def make_call(options)
      result = RwApiMicroservice.make_request(options, credentials)
      unless check_errors(result.status.to_i, result.body)
        MultiJson.load("[#{result.body.to_s}]")[0]
      end
      initialize_options
      @response = result.body
    end

    def check_errors(status, body)
      case status
      when 500
        initialize_options
        raise RwApiMicroservice::ServerError.new(status, body)
      when 401
        initialize_options
        raise RwApiMicroservice::NoTokenError.new(status, body)
      when 404
        initialize_options
        raise RwApiMicroservice::NotFoundError.new(status, body)
      else
        return false
      end
    end
  end
end
