Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/signup', to: 'auth#signup'
      post 'auth/login', to: 'auth#login'
    end
  end
end
