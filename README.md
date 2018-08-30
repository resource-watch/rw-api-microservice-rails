# Control Tower registration Rails engine

Rails engine that integrates your rails-build microservices with [Control Tower](https://github.com/control-tower/control-tower)

[![Build Status](https://travis-ci.org/control-tower/ct-register-microservice-rails.svg?branch=master)](https://travis-ci.org/control-tower/ct-register-microservice-rails)

## Installation

Installing using `bundler` is recommended:

```ruby
# Gemfile

gem 'ct-register-microservice-rails'
```

And then execute:
```bash
$ bundle install
```

## Usage

Create a Rails initializer to define your connection settings and connect to Control Tower. 
```ruby
#config/initializers/ct_register_microservice.rb
CtRegisterMicroservice.configure do |config|
      config.ct_url = 'http://your-control-tower-url.com'
      config.url = 'http://your-rails-microservice-url.com'
      config.ct_token = 'Control Tower auth token'
      config.swagger = __dir__ + 'path/to/your/CT/registration/json/file'
      config.name = 'Name of your microservice'
      config.dry_run = false
    end
```

After the configuration values are defined, use the following code to have your microservice register itself on Control Tower:

 ```ruby
ct_connection = CtRegisterMicroservice::ControlTower.new()
ct_connection.register_service()
```

Keep in mind that this registration process will result in Control Tower contacting your Rails server almost immediately.
Using it in Rails initializers will trigger it *before* the Rails HTTP server is up, causing the registration process to fail.

For this purpose, this engine also includes a Rake task that can be used to trigger this registration process:

```bash
rake ct_register_microservice:register
```


## Current methods

This engine currently implements two convenience methods:

- `register_microservice()` registers the current Rails microservice on Control Tower. Is currently full-featured and supported
- `microservice_request()` makes a request to a different microservice within the CT environment. Currently in development, may not work as expected

## Config reference

If you want to use the gem in dry run mode (no calls actually made to CT), set:

```ruby
CtRegisterMicroservice.configure do |config|
  config.dry_run = true
end
```

## Contributing
Feel free to contribute, pull requests are welcome.

## License
The engine is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
