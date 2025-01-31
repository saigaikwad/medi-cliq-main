class DoctorsController < ApplicationController
  before_action :authenticate_doctor!

  def dashboard
    @patients = Patient.all
    @medicines = Medicine.all
  end
end
