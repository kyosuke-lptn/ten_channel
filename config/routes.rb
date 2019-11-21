Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions', registrations: 'users/registrations',
    passwords: 'users/passwords', confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
  }
  root 'home#index'

  devise_scope :user do
    get 'users', to: 'users/registrations#show', as: :user
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
