require_dependency "ct_register_microservice/application_controller"

module CtRegisterMicroservice
  class InfoController < ApplicationController
    def info
      if CtRegisterMicroservice.config.swagger and File.exist?(CtRegisterMicroservice.config.swagger)
        @docs = MultiJson.load(File.read(CtRegisterMicroservice.config.swagger))
        render json: @docs
      else
        render json: { success: false, message: 'Could not load info file' }, status: 500
      end
    end

    def ping
      render json: { success: true, message: 'RW Tags online' }, status: 200
    end
  end
end
