module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @doctors = Doctor.all
      @patients = Patient.all
      @medicines = Medicine.all
      @low_stock_medicines = Medicine.where("stock < ?", 10) # Adjust threshold as needed
    end
  end
end
