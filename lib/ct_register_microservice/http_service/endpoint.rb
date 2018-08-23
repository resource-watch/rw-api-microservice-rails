module CtRegisterMicroservice
  module HTTPService
    class Endpoint

      attr_reader :options, :credentials

      def initialize(options, credentials = {})
        @options = options
        @credentials  = credentials
      end

      def get
        endpoint_uri
      end

      private

      def endpoint_uri
        options.endpoint
      end

    end
  end
  Endpoint = HTTPService::Endpoint
end

