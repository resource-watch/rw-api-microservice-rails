Rails.application.routes.draw do
  mount CtRegisterMicroservice::Engine => "/ct-register-microservice"
end
