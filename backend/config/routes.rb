Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/signup', to: 'auth#signup'
      post 'auth/login',  to: 'auth#login'

      resources :habits do
        resources :habit_entries, only: %i[index create]
      end
    end
  end
end
