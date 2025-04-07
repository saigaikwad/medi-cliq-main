module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin_user!

    def index
      @doctors_count = Doctor.count
      @patients_count = Patient.count
      @appointments_count = Appointment.count
      @prescriptions_count = Prescription.count
      @medicines_count = Medicine.count
      @categories_count = Category.count
    end
  end
end
