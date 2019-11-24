Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions', registrations: 'users/registrations',
    passwords: 'users/passwords', confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
  }
  root 'home#index'

  resources :posting_threads
  namespace :users do
    resource :profiles, only: :show
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
