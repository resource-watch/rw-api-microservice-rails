require_dependency "rw_api_microservice/application_controller"

module RwApiMicroservice
  class InfoController < ApplicationController
    def ping
      render json: { success: true }, status: 200
    end
  end
end
