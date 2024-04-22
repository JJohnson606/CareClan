Rails.application.routes.draw do
  get 'home/chartview'
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
  get '/medical_records/partials/:record_type', to: 'medical_records#load_partial', as: 'load_medical_record_partial'
  get '/medical_records/fields_partials/:record_type', to: 'medical_records#fields_partial', as: 'fields_partial'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # config/routes.rb

end
