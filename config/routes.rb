Rails.application.routes.draw do
  # Devise authentication for doctors and patients
  devise_for :doctors, controllers: { registrations: 'doctors/registrations' }
  devise_for :patients, skip: [:registrations], controllers: { passwords: 'devise/passwords' }

  # Doctors Dashboard
  get 'doctors/dashboard', to: 'doctors#dashboard'

  # Prescriptions
  resources :prescriptions, only: [:index, :show]
  
  # Medicines & Categories
  resources :medicines
  resources :categories

  # Nested routes: Doctors can only see their own patients
  resources :doctors, only: [] do
    member do
      get 'dashboard'  # Fix this route for member-based dashboard
    end

    resources :patients, module: :doctors, only: [:new, :create, :index]
  end

  # Root path
  root 'doctors#dashboard'
end
