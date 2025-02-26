module Admin
  class DoctorsController < ApplicationController
    before_action :authenticate_admin_user! # Ensures only admins can access
    before_action :find_doctor, only: %i[show edit update destroy]

    # LIST ALL DOCTORS
    def index
      @q = Doctor.ransack(params[:q])
      @doctors = @q.result.order(created_at: :desc).page(params[:page])
    end

    # SHOW A SINGLE DOCTOR
    def show
    end

    # NEW DOCTOR FORM
    def new
      @doctor = Doctor.new
    end

    # CREATE A NEW DOCTOR
    def create
      @doctor = Doctor.new(doctor_params)
      if @doctor.save
        redirect_to admin_doctor_path(@doctor), notice: "Doctor created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # EDIT DOCTOR FORM
    def edit
    end

    # UPDATE DOCTOR DETAILS
    def update
      if @doctor.update(doctor_params)
        redirect_to admin_doctor_path(@doctor), notice: "Doctor updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE DOCTOR
    def destroy
      @doctor = Doctor.find(params[:id])

      if @doctor.destroy
        redirect_to admin_doctors_path, notice: "Doctor successfully deleted."
      else
        redirect_to admin_doctors_path, alert: "Unable to delete doctor. It might have dependent records."
      end
    end


    private

    # FIND DOCTOR (Used in `show`, `edit`, `update`, `destroy`)
    def find_doctor
      @doctor = Doctor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_doctors_path, alert: "Doctor not found."
    end

    # STRONG PARAMETERS
    def doctor_params
      allowed_params = [:first_name, :last_name, :email, :phone_number, :license_no, :education]

      # Only permit password fields if they are provided (to avoid validation errors)
      if params[:doctor][:password].present?
        allowed_params += [:password, :password_confirmation]
      end

      params.require(:doctor).permit(allowed_params)
    end

  end
end
