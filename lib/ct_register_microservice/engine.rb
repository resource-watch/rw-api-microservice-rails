module CtRegisterMicroservice
  class Engine < ::Rails::Engine
    isolate_namespace CtRegisterMicroservice

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
