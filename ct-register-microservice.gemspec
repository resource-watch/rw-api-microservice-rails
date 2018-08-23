$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "ct_register_microservice/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ct-register-microservice"
  s.version     = CtRegisterMicroservice::VERSION
  s.authors       = ["Tiago Garcia", "Vizzuality"]
  s.email         = ["info@vizzuality.com"]
  s.homepage      = "http://vizzuality.com"
  s.license       = "MIT"
  s.summary       = "Control Tower connector service"
  s.description   = "This gem allows your Rails-built microservice to register itself on Control Tower"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"
  s.add_dependency 'faraday'
  s.add_dependency 'multi_json'

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "sqlite3"
end
