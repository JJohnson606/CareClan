Rails.application.routes.draw do
  get 'home/chartview'
  root "welcome#index"
  resources :medical_records do
    get 'partials/:record_type', to: 'medical_records#load_partial', on: :collection, as: 'load_partial'
    get 'fields_partials/:record_type', to: 'medical_records#fields_partial', on: :collection, as: 'fields_partial'
  end
  
  resources :approvals
  resources :posts do
    member do
      put 'approve'
      put 'disapprove'
    end
    resources :comments, only: [:create, :new, :show] # Nested within posts for creation of new comments
  end

  resources :comments, except: [:create, :new] do
    member do
      put 'approve'
      put 'disapprove'
    end
    resources :comments, only: [:create, :new] # Allows creation of replies to comments
  end

  devise_for :users
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  # get '/medical_records/partials/:record_type', to: 'medical_records#load_partial', as: 'load_medical_record_partial'
  # get '/medical_records/fields_partials/:record_type', to: 'medical_records#fields_partial', as: 'fields_partial'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # config/routes.rb

end
