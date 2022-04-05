Rails.application.routes.draw do
  root to: 'users#new'
  get '/:id', to: 'users#show', as: 'user_show'
  resources :users
  resources :sessions, only: [:new, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
