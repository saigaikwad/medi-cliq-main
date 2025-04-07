class ApplicationController < ActionController::Base
  before_action :authenticate_admin2!, if: -> { request.path.start_with?('/admin2') }

  def authenticate_user!
    if admin2_signed_in?
      authenticate_admin2!
    elsif doctor_signed_in?
      authenticate_doctor!
    elsif patient_signed_in?
      authenticate_patient!
    else
      redirect_to root_path, alert: "You need to sign in first."
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin2)
      admin2_root_path
    else
      super
    end
  end
  

  private

  def configure_devise_layout
    self.class.layout "application"
  end
  
end
