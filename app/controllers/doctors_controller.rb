class DoctorsController < ApplicationController
  before_action :authenticate_doctor!

  def dashboard
    @patients = Patient.all
    @medicines = Medicine.all
    @doctor = current_doctor 
  end
end
