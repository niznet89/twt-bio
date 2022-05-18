Rails.application.routes.draw do
  root to: 'users#home'
  get '/:id', to: 'users#show', as: 'user_show'
  resources :users
  resources :socials, only: [:update]
  resources :projects, only: [:create]
  resources :sessions, only: [:new, :create]
  resources :widgets
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
