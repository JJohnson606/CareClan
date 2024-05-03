Rails.application.routes.draw do
  root "welcome#index"

  resources :medical_records do
    collection do
      get 'partials/:record_type', to: 'medical_records#load_partial', as: 'load_partial'
      get 'fields_partials/:record_type', to: 'medical_records#fields_partial', as: 'fields_partial'
    end
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

  resources :clans do
    resources :clan_memberships, only: [:create, :destroy, :index, :show]
    member do
      get 'show_members'
      patch 'toggle_trust/:user_id', to: 'clans#toggle_trust', as: 'toggle_trust'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine => 'good_job'
  end
end
