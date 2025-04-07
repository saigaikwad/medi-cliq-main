Rails.application.routes.draw do
  # Devise for Admins
  devise_for :admin_users, path: 'admin'

  # Devise for Doctors (custom controllers)
  devise_for :doctors, controllers: { sessions: 'doctors/sessions', registrations: 'doctors/registrations'
  }

  # Devise for Patients (sessions only, no registration)
  devise_for :patients, controllers: { sessions: 'patients/sessions'
  }, skip: [:registrations]

  # Sidekiq Monitoring UI
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Authenticated Root Paths
  authenticated :doctor do
    root 'doctors#dashboard', as: :authenticated_doctor_root
  end

  authenticated :patient do
    root 'patients#dashboard', as: :authenticated_patient_root
  end

  # Default Root Path (for unauthenticated users)
  root 'home#index'

  # Home
  get 'home/index', to: 'home#index'

  # Patients
  get 'patients/dashboard', to: 'patients#dashboard'
  get 'patients/edit_password', to: 'patients#edit_password'
  patch 'patients/update_password', to: 'patients#update_password'

  # Doctors
  get 'doctors/dashboard', to: 'doctors#dashboard'

  # Nested: Doctors managing their patients
  resources :doctors, only: [] do
    member do
      get 'dashboard'
    end

    resources :patients, module: :doctors, only: [:new, :create, :index]
  end

  # Appointments
  resources :appointments, only: [:new, :create, :index, :show, :update] do
    member do
      patch :confirm
      patch :cancel
      get :start_video_call
    end
  end

  get 'appointments/:id/video_call', to: 'appointments#start_video_call', as: 'video_call'
  post 'start_video_call', to: 'appointments#start_video_call'

  # Medicines & Categories
  resources :medicines
  resources :categories

  # Prescriptions
  resources :prescriptions, only: [:index, :show]

  # AdminUser namespace
  namespace :admin do
    root to: "dashboard#index"

    resources :medicines do
      member do
        get 'new_batch'
        post'create_batch'
      end
    end

    resources :patients do
      post :authenticate, on: :member
      post :lock, on: :member
    end

    resources :doctors do
      member do
        patch :restore
      end
    end

    resources :appointments
    resources :prescriptions
    resources :categories
  end

end
