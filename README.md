# Control Tower registration Rails engine

Rails engine that integrates your rails-build microservices with [Control Tower](https://github.com/control-tower/control-tower)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ct-register-microservice-rails'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install ct-register-microservice-rails
```

## Usage

Create a Rails initializer to define your connection settings and connect to Control Tower. 
```ruby
#config/initializers/cartowrap.rb
require 'ct-register-microservice-rails'
CtRegisterMicroservice.configure do |config|
  config.account = your_cartodb_account
  config.api_key = your_api_key
  config.carto_url = your_carto_url # only if you have a custom Carto installation in your own server
end

# Any other place in your code 
api_call = CtRegisterMicroservice::API.new
```

## Current methods

```ruby
send_query(query)
get_synchronizations
get_synchronization(import_id)
check_synchronization(import_id)
force_synchronization(import_id)
create_synchronization(url, interval, sync_options={})
delete_synchronization(import_id)
```

## Config reference

If you want to use the gem in dry run mode (no calls actually made to the CartoDB API), set:

```ruby
Cartowrap.configure do |config|
  config.dry_run = true
end
```

## Contributing
Feel free to contribute pull requests are welcome.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
