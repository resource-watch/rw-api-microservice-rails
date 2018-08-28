module CtRegisterMicroservice
  class ControlTower
    def initialize()
      if CtRegisterMicroservice.config.ct_url.nil?
        raise MissingConfigError, 'Could not register microservice - No Control Tower URL defined'
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

      @dry_run = CtRegisterMicroservice.config.dry_run || false
      @credentials = {}
      @credentials['ct_url'] = CtRegisterMicroservice.config.ct_url
      @options = OpenStruct.new
    end

    attr_reader :credentials, :options, :response, :ct_url, :swagger, :name

    def send_query(query)
      options.endpoint = "sql"
      options.query_string = true
      options.q = query
      result = make_call(options)
      result
    end

    def post_query(query)
      options.http_method = "post"
      options.query_string = false
      options.endpoint = "sql_post"
      result = make_call(options)
      result
    end

    def register_service(name, url, active)
      options.http_method = "post"
      options.endpoint = "api/v1/microservice"
      options.query_string = false
      options.body = {
        name: name,
        url: url,
        active: !!active
      }
      result = make_call(options)
      result
    end

    def microservice_request(uri, method, headers = {}, body = nil)
      options.http_method = method
      options.endpoint = uri
      options.headers = headers
      options.headers['Authorization'] = 'Bearer ' + CtRegisterMicroservice.config.ct_token
      options.body = body
      result = make_call(options)
      result
    end

    def initialize_options
      @options = OpenStruct.new
    end

    private

    def validate_sync_options(sync_options)
      valid_options = [:type_guessing, :quoted_fields_guessing, :content_guessing]
      sync_options = sync_options.map { |o| ((valid_options.include? o[0]) && !!o[1] == o[1]) ? o : nil }.compact.to_h
      sync_options
    end

    def make_call(options)
      return fake_response if CtRegisterMicroservice.config.dry_run

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
          raise CtRegisterMicroservice::ServerError.new(status, '')
        when 401
          initialize_options
          raise CtRegisterMicroservice::NoTokenError.new(status, body)
        when 404
          initialize_options
          raise CtRegisterMicroservice::NotFoundError.new(status, '')
        else
          return false
      end
    end

    def fake_response
      CtRegisterMicroservice::HTTPService::Response.new(200, "", "")
    end
  end
end
