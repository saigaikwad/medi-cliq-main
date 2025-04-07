class ApplicationController < ActionController::Base

  def authenticate_admin!
    authenticate_admin_user!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
  
end
