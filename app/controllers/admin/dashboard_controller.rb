module Admin
  class DashboardController < BaseController
    #add admin authentication here
    before_action :authenticate_admin_user!

    def index
      # Collect some quick stats for the dashboard
      @patients_count      = Patient.count
      @doctors_count       = Doctor.count
      @prescriptions_count = Prescription.count
      @appointments_count  = Appointment.count
      @medicines_count     = Medicine.count
    end
  end
end