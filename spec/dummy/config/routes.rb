Rails.application.routes.draw do
  mount RwApiMicroservice::Engine => "/"
end
