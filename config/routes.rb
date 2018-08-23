CtRegisterMicroservice::Engine.routes.draw do
  get :info, action: :info, controller: 'info'
  get :ping, action: :ping, controller: 'info'
end
