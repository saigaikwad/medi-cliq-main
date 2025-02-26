Rails.application.routes.draw do
  get 'home/index'

  # Devise authentication
  devise_for :doctors, controllers: { sessions: 'doctors/sessions', registrations: 'doctors/registrations' }
  devise_for :patients, controllers: { sessions: 'patients/sessions' }, only: [:sessions, :passwords]
  devise_for :admin_users, path: 'admin_auth'

  # Dashboard redirects
  authenticated :patient do
    root 'patients#dashboard', as: :authenticated_patient_root
  end

  authenticated :doctor do
    root 'doctors#dashboard', as: :authenticated_doctor_root
  end

  # Public homepage for non-authenticated users
  root 'home#index'

  # Routes
  resources :prescriptions, only: [:index, :show]
  resources :medicines
  resources :categories
  resources :appointments, only: [:new, :create, :index, :show, :update] do
    member do
      patch :confirm
      patch :cancel
      get :video_call
    end
  end

  # Password editing routes
  get 'patients/edit_password', to: 'patients#edit_password'
  patch 'patients/update_password', to: 'patients#update_password'

  # Nested routes: Doctors managing patients
  resources :doctors, only: [] do
    member do
      get 'dashboard'
    end

    resources :patients, module: :doctors, only: [:new, :create, :index]
  end

  # Admin namespace (single block)
  namespace :admin do
    root to: "dashboard#index"
    resources :patients
    resources :doctors
    resources :prescriptions
    resources :appointments
    resources :medicines
  end


  # Sidekiq dashboard
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
