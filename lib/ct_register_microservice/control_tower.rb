require 'ct_register_microservice/errors'

module CtRegisterMicroservice
  class ControlTower
    def initialize
      if CtRegisterMicroservice.config.ct_url.nil?
        raise MissingConfigError, 'Could not register microservice - No Control Tower URL defined'
      end
      if CtRegisterMicroservice.config.url.nil?
        raise MissingConfigError, 'Could not register microservice - No self URL defined'
      end
      if CtRegisterMicroservice.config.ct_token.nil?
        raise MissingConfigError, 'Could not register microservice - No Control Tower auth token found'
      end
      if CtRegisterMicroservice.config.swagger.nil?
        raise MissingConfigError, 'Could not register microservice - No swagger file defined'
      end
      if !File.exist?(CtRegisterMicroservice.config.swagger)
        raise MissingConfigError, 'Could not register microservice - Swagger file path ' + File.absolute_path(CtRegisterMicroservice.config.swagger) + 'does not match a file'
      end
      if CtRegisterMicroservice.config.name.nil?
        raise MissingConfigError, 'Could not register microservice - Microservice name not defined'
      end

      @options = OpenStruct.new
    end

    attr_reader :credentials, :options, :response, :ct_url, :swagger, :name, :url

    def register_service(active = true)
      options.http_method = "post"
      options.endpoint = "/api/v1/microservice"
      options.query_string = false
      options.body = {
        name: CtRegisterMicroservice.config.name,
        url: CtRegisterMicroservice.config.url,
        active: !!active
      }.to_json
      result = make_call(options)
      result
    end

    # TODO: make sure it works as intended, add unit tests
    def microservice_request(uri, method, headers = {}, body = nil)
      options.http_method = method
      options.endpoint = uri
      options.headers = headers
      options.headers['authorization'] = 'Bearer '+CtRegisterMicroservice.config.ct_token
      options.body = body
      result = make_call(options)
      result
    end

    def initialize_options
      @options = OpenStruct.new
    end

    private

    def make_call(options)
      result = CtRegisterMicroservice.make_request(options, credentials)
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
        raise CtRegisterMicroservice::ServerError.new(status, body)
      when 401
        initialize_options
        raise CtRegisterMicroservice::NoTokenError.new(status, body)
      when 404
        initialize_options
        raise CtRegisterMicroservice::NotFoundError.new(status, body)
      else
        return false
      end
    end
  end
end
