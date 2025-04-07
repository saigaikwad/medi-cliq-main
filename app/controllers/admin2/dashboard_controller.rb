class Admin2::DashboardController < ApplicationController
  before_action :authenticate_admin2!

  def index
    @total_doctors = Doctor.count
    @total_patients = Patient.count
    @total_prescriptions = Prescription.count
    @total_medicines = Medicine.count
  end
end
