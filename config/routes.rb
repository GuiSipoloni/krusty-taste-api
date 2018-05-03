Rails.application.routes.draw do
  post 'user_token', to: 'user_token#create'
  namespace 'api' do
    namespace 'v1' do
      
      get    '/users', to: 'users#index'
      post   '/users/create', to: 'users#create'
      patch  '/user/:id', to: 'users#update'
      delete '/user/:id', to: 'users#destroy'

      resources :recipes
    end
  end
end
