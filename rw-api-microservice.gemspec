$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rw_api_microservice/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rw-api-microservice"
  s.version     = RwApiMicroservice::VERSION
  s.authors       = ["Tiago Garcia", "Vizzuality"]
  s.email         = ["info@vizzuality.com"]
  s.homepage      = "https://vizzuality.com"
  s.license       = "MIT"
  s.summary       = "RW API connector service"
  s.description   = "This gem allows your Rails-built microservice to easily integrate with the RW API"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 7.0.4"
  s.add_dependency 'httparty'
  s.add_dependency 'multi_json'

  s.add_development_dependency "rake"
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-console'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "sqlite3"
end
