class Admin::DoctorsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_doctor, only: [:show, :edit, :update, :destroy, :restore]

  def index
    @doctors = Doctor.with_deleted.includes(:appointments, :patients)
    @analytics = {
      recently_added: Doctor.order(created_at: :desc).limit(5),
      most_appointments: Doctor.joins(:appointments).group(:id).order("COUNT(appointments.id) DESC").limit(5),
      total_patients_per_doctor: Doctor.active.map { |doc| [doc.full_name, doc.patients.uniq.count] }.to_h
    }
  end

  def show; end

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

  def edit; end

  def update
    if @doctor.update(doctor_params)
      redirect_to admin_doctor_path(@doctor), notice: "Doctor updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @doctor.soft_delete!
    redirect_to admin_doctors_path, notice: "Doctor was soft deleted."
  end
  
  def restore
    @doctor.update(deleted_at: nil)
    redirect_to admin_doctors_path, notice: "Doctor was restored."
  end

  private

  def set_doctor
    @doctor = Doctor.with_deleted.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email, :phone_number, :license_no, :education, :password, :password_confirmation)
  end
end