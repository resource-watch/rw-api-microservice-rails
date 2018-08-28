Rails.application.routes.draw do
  mount CtRegisterMicroservice::Engine => "/"
end
