Rails.application.routes.draw do
  get 'home/index'

  # Devise authentication for doctors and patients
  devise_for :doctors, controllers: { sessions: 'doctors/sessions', registrations: 'doctors/registrations' }
  devise_for :patients, controllers: { sessions: 'patients/sessions' }, skip: [:registrations]

  # Patient Dashboard Redirect for authenticated patients
  authenticated :patient do
    root 'patients#dashboard', as: :authenticated_patient_root
  end

  # Doctor Dashboard Redirect for authenticated doctors
  authenticated :doctor do
    root 'doctors#dashboard', as: :authenticated_doctor_root
  end

  # Public Homepage (for non-logged-in users)
  root 'home#index'

  # Additional public routes
  get 'patients/dashboard', to: 'patients#dashboard'
  get 'doctors/dashboard', to: 'doctors#dashboard'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Prescriptions routes
  resources :prescriptions, only: [:index, :show]

  # Medicines & Categories
  resources :medicines
  resources :categories

  # Appointments routes with additional member actions
  resources :appointments, only: [:new, :create, :index, :show, :update] do
    member do
      patch :confirm
      patch :cancel
      get :video_call
    end
  end

  # Additional route for video call (if needed)
  get 'appointments/:id/video_call', to: 'appointments#start_video_call', as: 'video_call'

  # Routes for password editing for patients
  get 'patients/edit_password', to: 'patients#edit_password'
  patch 'patients/update_password', to: 'patients#update_password'

  # Nested routes: Doctors can manage their own patients
  resources :doctors, only: [] do
    member do
      get 'dashboard'  # Doctor-specific dashboard
    end

    resources :patients, module: :doctors, only: [:new, :create, :index]
  end

  # For admins, change the Devise path to avoid conflict
  devise_for :admin_users, path: 'admin_auth'

  # AdminUser namespace routes (accessible after admin login)
  namespace :admin do
    root to: "dashboard#index"
    resources :patients
    resources :doctors
    resources :prescriptions
    resources :appointments
    resources :medicines
  end
end
