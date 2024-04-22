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
    resources :comments, only: [:create, :new, :show]
  end

  resources :comments, except: [:create, :new] do
    member do
      put 'approve'
      put 'disapprove'
    end
    resources :comments, only: [:create, :new]
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

end
