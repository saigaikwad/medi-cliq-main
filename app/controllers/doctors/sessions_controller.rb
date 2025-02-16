class Doctors::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    doctors_dashboard_path  # ✅ Redirect doctors to their dashboard
  end
end
