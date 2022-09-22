# Api Gateway registration Rails engine

Rails engine that integrates your rails-build microservices with the [RW API](https://api.resourcewatch.org/)

[![Build Status](https://travis-ci.org/control-tower/rw-api-microservice-rails.svg?branch=master)](https://travis-ci.org/control-tower/rw-api-microservice-rails)
[![Test Coverage](https://api.codeclimate.com/v1/badges/85eeb71033246c5c259d/test_coverage)](https://codeclimate.com/github/control-tower/rw-api-microservice-rails/test_coverage)

## Installation

Installing using `bundler` is recommended:

```ruby
# Gemfile

gem 'rw-api-microservice-rails'
```

And then execute:
```bash
$ bundle install
```

## Usage

Create a Rails initializer to define your connection settings to the RW API Gateway 

```ruby
#config/initializers/rw_api_microservice.rb
RwApiMicroservice.configure do |config|
      config.gateway_url = 'http://your-gateway-url.com'
      config.microservice_token = 'Gateway auth token'
    end
```


## Current methods

This engine currently implements a convenience method:

- `microservice_request()` makes a request to a different microservice within the RW API environment.

## Contributing
Feel free to contribute, pull requests are welcome.

## License
The engine is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## Testing

```bash
bundle exec rspec spec
```
