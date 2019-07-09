Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'auth/register', to: 'users#register'
      post 'auth/login', to: 'users#login'
      put 'auth/refresh', to: 'users#refresh_token'
      post 'groups', to: 'groups#create'
    end
  end
end
