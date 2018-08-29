namespace :ct_register_microservice do
  desc 'Register microservice on configured Control Tower'
  task register: [:environment] do
    ct_connection = CtRegisterMicroservice::ControlTower.new()
    ct_connection.register_service()
  end
end
