module CtRegisterMicroservice

  class MissingConfigError < StandardError;
  end

  class CtRegisterMicroserviceError < StandardError;
  end

  class AppSecretNotDefinedError < ::CtRegisterMicroservice::CtRegisterMicroserviceError;
  end

  class APIError < ::CtRegisterMicroservice::CtRegisterMicroserviceError
    attr_accessor :ct_error_type, :ct_error_code, :ct_error_subcode, :ct_error_message,
                  :ct_error_user_msg, :ct_error_user_title, :http_status, :response_body


    def initialize(http_status, response_body, error_message = nil)
      if response_body
        self.response_body = response_body.strip
      else
        self.response_body = ''
      end
      self.http_status = http_status

      if error_message && error_message.is_a?(String)
        message = error_message
      else
        unless error_message
          begin
            errors = MultiJson.load(response_body) if response_body
            error_array = errors['errors'].map { |n| n['detail'] } if errors.key? 'errors'
          rescue
          end
          error_array ||= []
        end

        if error_array.nil? or error_array.empty?
          message = self.response_body
        else
          message = error_array.join(', ')
        end
      end

      super(message)
    end
  end

  # CT returned an invalid response body
  class BadCTResponse < APIError;
  end

  # CT responded with an error while attempting to request an access token
  class OAuthTokenRequestError < APIError;
  end

  # Any error with a 5xx HTTP status code
  class ServerError < APIError;
  end

  # Any error with a 4xx HTTP status code
  class ClientError < APIError;
  end

  # All API authentication failures.
  class AuthenticationError < ClientError;
  end

  # not found
  class NotFoundError < APIError;
  end

  # not found
  class NoTokenError < APIError;
  end


end
