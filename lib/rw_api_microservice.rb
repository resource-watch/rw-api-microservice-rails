require 'rw_api_microservice/engine'
require 'rw_api_microservice/gateway'
require 'rw_api_microservice/http_service'
require 'rw_api_microservice/errors'
require 'multi_json'
require 'ostruct'

module RwApiMicroservice
  class << self
    attr_accessor :http_service, :config

    def configure
      yield config
    end

    def config
      @config ||= OpenStruct.new
    end
  end

  def self.http_service=(service)
    @http_service = service
  end

  def self.make_request(options, credentials = {})
    http_service.make_request(options, credentials)
  end

  self.http_service = HTTPService
end
