class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @doctors = Doctor.all
    @low_stock_medicines = Medicine.where("stock_quantity < ?", 10) # Example threshold
  end
end
