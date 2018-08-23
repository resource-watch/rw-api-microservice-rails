module CtRegisterMicroservice

  class MissingCTURLError < StandardError;
  end

  class MissingCTTokenError < StandardError;
  end

  class CtRegisterMicroserviceError < StandardError;
  end

  class AppSecretNotDefinedError < ::CtRegisterMicroservice::CtRegisterMicroserviceError;
  end

  class APIError < ::CtRegisterMicroservice::CtRegisterMicroserviceError
    attr_accessor :ct_error_type, :ct_error_code, :ct_error_subcode, :ct_error_message,
                  :ct_error_user_msg, :ct_error_user_title, :http_status, :response_body


    def initialize(http_status, response_body, error_info = nil)
      if response_body
        self.response_body = response_body.strip
      else
        self.response_body = ''
      end
      self.http_status = http_status

      if error_info && error_info.is_a?(String)
        message = error_info
      else
        unless error_info
          begin
            error_info = MultiJson.load(response_body)['error'] if response_body
          rescue
          end
          error_info ||= {}
        end

        self.ct_error_type = error_info["type"]
        self.ct_error_code = error_info["code"]
        self.ct_error_subcode = error_info["error_subcode"]
        self.ct_error_message = error_info["message"]
        self.ct_error_user_msg = error_info["error_user_msg"]
        self.ct_error_user_title = error_info["error_user_title"]

        error_array = []
        %w(type code error_subcode message error_user_title error_user_msg).each do |key|
          error_array << "#{key}: #{error_info[key]}" if error_info[key]
        end

        if error_array.empty?
          message = self.response_body
        else
          message = error_array.join(', ')
        end
      end
      message += " [HTTP #{http_status}]" if http_status

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
