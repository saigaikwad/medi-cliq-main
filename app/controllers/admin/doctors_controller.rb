module Admin
  class DoctorsController < ApplicationController
    # Optionally, add before_action :authenticate_admin!

    def index
      @doctors = Doctor.all
    end

    def show
      @doctor = Doctor.find(params[:id])
    end

    def new
      @doctor = Doctor.new
    end

    def create
      @doctor = Doctor.new(doctor_params)
      if @doctor.save
        redirect_to admin_doctor_path(@doctor), notice: "Doctor created successfully."
      else
        render :new
      end
    end

    def edit
      @doctor = Doctor.find(params[:id])
    end

    def update
      @doctor = Doctor.find(params[:id])
      if @doctor.update(doctor_params)
        redirect_to admin_doctor_path(@doctor), notice: "Doctor updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @doctor = Doctor.find(params[:id])
      @doctor.destroy
      redirect_to admin_doctors_path, notice: "Doctor deleted successfully."
    end

    private

    def doctor_params
      params.require(:doctor).permit(:name, :specialization, :email, :phone, :experience)
      # Adjust permitted parameters according to your Doctor model attributes.
    end
  end
end
