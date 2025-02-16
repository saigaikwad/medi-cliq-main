class Patients::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    patients_dashboard_path  # Redirect to patient dashboard after login
  end
end
