Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions', registrations: 'users/registrations',
    passwords: 'users/passwords', confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
  }
  root 'home#index'

  namespace :users do
    resource :profiles, only: :show
  end
  resources :posting_threads
  resources :comments, only: [:create, :update, :destroy] do
    collection do
      post 'like'
    end
  end
  resources :search, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
