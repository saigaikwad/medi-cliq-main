Rails.application.routes.draw do
  namespace :patients do
    get 'sessions/new'
    get 'sessions/create'
    get 'sessions/destroy'
  end
  get 'doctors/dashboard'
  get 'prescriptions/index'
  get 'prescriptions/show'

  devise_for :patients, skip: [:registrations], controllers: { passwords: 'devise/passwords' }

  resources :prescriptions, only: [:index, :show]
  resources :medicines
  resources :categories

  devise_for :doctors, controllers: { registrations: 'doctors/registrations' }

  namespace :doctors do
    resources :patients, only: [:new, :create, :index, :show]
  end

 


  root 'doctors#dashboard'
  #root "patients/sessions#new"

end
