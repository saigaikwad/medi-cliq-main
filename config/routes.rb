Rails.application.routes.draw do
  namespace :admin2 do
    root "dashboard#index"
    resources :medicines
    resources :categories
  end
  
  devise_for :admin2s
 
 
  get 'home/index'
  # Devise authentication for doctors and patients
  devise_for :doctors, controllers: { sessions: 'doctors/sessions', registrations: 'doctors/registrations' }

  devise_for :patients, controllers: { sessions: 'patients/sessions' }, skip: [:registrations]

# ✅ Ensure the patient dashboard route exists
get 'patients/dashboard', to: 'patients#dashboard'

# Patient Dashboard Redirect
authenticated :patient do
  root 'patients#dashboard', as: :authenticated_patient_root
end

  # Doctor Dashboard (Doctors only)
  authenticated :doctor do
    root 'doctors#dashboard', as: :authenticated_doctor_root
  end
  get 'doctors/dashboard', to: 'doctors#dashboard'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  

  # ✅ Public Homepage (for non-logged-in users)
  root 'home#index'  

  # ✅ Ensure the home page route exists
  get 'home/index', to: 'home#index'

  # Prescriptions
  resources :prescriptions, only: [:index, :show]

  # Medicines & Categories
  resources :medicines
  resources :categories
  resources :appointments, only: [:new, :create, :index, :show, :update] do
    member do
      patch :confirm
      patch :cancel
      get :start_video_call
    end
  end

  get 'appointments/:id/video_call', to: 'appointments#start_video_call', as: 'video_call'

  post 'start_video_call', to: 'appointments#start_video_call'


  resources :appointments, only: [:new, :create, :index, :update, :show]

  devise_for :admins
  namespace :admin do
    resources :medicines
    resources :doctors, only: [:index, :show]
    get 'dashboard', to: 'dashboard#index'
    root to: 'dashboard#index'
  end
  


  get 'patients/edit_password', to: 'patients#edit_password'
  patch 'patients/update_password', to: 'patients#update_password'

  # Nested routes: Doctors can manage their own patients
  resources :doctors, only: [] do
    member do
      get 'dashboard'  # Doctor-specific dashboard
    end

    resources :patients, module: :doctors, only: [:new, :create, :index]
  end
end
