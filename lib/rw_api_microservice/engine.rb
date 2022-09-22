require 'rw_api_microservice'

module RwApiMicroservice
  class Engine < ::Rails::Engine
    isolate_namespace RwApiMicroservice

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
