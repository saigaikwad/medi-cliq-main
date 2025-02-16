class PatientsController < ApplicationController
  before_action :authenticate_patient! # Ensure only logged-in patients can access
  before_action :set_patient, only: [:dashboard, :edit_password, :update_password]

  def dashboard
    @prescriptions = @patient.prescriptions # Show only the logged-in patient's prescriptions
    @appointments = current_patient.appointments.includes(:doctor)
  end

  def edit_password
    # Show password change form
  end

  def update_password
    if @patient.update(password_params)
      bypass_sign_in(@patient) # Keep patient signed in after password change
      redirect_to patient_dashboard_path, notice: "Password updated successfully!"
    else
      flash[:alert] = @patient.errors.full_messages.join(", ")
      render :edit_password
    end
  end

  private

  def set_patient
    @patient = current_patient # Get the currently logged-in patient
  end

  def password_params
    params.require(:patient).permit(:password, :password_confirmation)
  end
end
