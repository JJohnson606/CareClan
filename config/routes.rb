Rails.application.routes.draw do
  root "welcome#index"
  resources :medical_records
  resources :approvals
  resources :comments
  resources :posts do
    member do
      put 'approve'
      put 'disapprove'
    end
  end
  devise_for :users
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # config/routes.rb

end
