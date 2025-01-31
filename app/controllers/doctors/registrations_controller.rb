class Doctors::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :license_no, :phone_number, :education])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :license_no, :phone_number, :education])
  end
end
