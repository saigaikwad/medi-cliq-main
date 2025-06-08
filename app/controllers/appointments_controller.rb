class AppointmentsController < ApplicationController
  before_action :authenticate_patient!, only: [:new, :create]
  before_action :authenticate_doctor!, only: [:index, :update]
  before_action :set_appointment, only: [:show, :confirm, :cancel, :start_video_call] 

  def new
    @appointment = Appointment.new
    @doctors = current_patient.doctors.distinct
  end

  def create
    @appointment = current_patient.appointments.build(appointment_params)
    @appointment.status = "pending"

    if @appointment.save
      redirect_to patients_dashboard_path, notice: "Appointment request sent to doctor."
    else
      render :new
    end
  end

  def index
    if current_doctor
      @appointments = current_doctor.appointments
    elsif current_patient
      @appointments = current_patient.appointments
    else
      redirect_to root_path, alert: "Access denied."
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
    if params[:status].present?
      @appointment.update(status: params[:status])
      redirect_to appointments_path, notice: "Appointment status updated."
    else
      redirect_to appointments_path, alert: "Invalid status."
    end
  end

  def show
  end

  def confirm
    room_name = "video_call_#{@appointment.id}" # unique per appointment
    video_link = "https://meet.jit.si/#{room_name}" # or Zoom/Jitsi/WebRTC link
  
    if @appointment.update(status: "confirmed", video_call_link: video_link)
      respond_to do |format|
        format.html { redirect_to appointments_path, notice: "Appointment confirmed successfully." }
        format.js
      end
    else
      redirect_to appointments_path, alert: "Failed to update appointment."
    end
  end
  

  def cancel
    if @appointment.update(status: "cancelled")
      respond_to do |format|
        format.html { redirect_to appointments_path, notice: "Appointment cancelled." }
        format.js
      end
    else
      redirect_to appointments_path, alert: "Failed to cancel appointment."
    end
  end

  def start_video_call
    if @appointment.video_call_link.present?
      redirect_to @appointment.video_call_link, allow_other_host: true
    else
      redirect_to appointments_path, alert: "Video call link is not available yet."
    end
  end
  
  
  

  private
  def set_appointment
    Rails.logger.debug "Params ID: #{params[:id]}"  # Logs the ID received
  
    @appointment = Appointment.find_by(id: params[:id])
  
    if @appointment.nil?
      Rails.logger.debug "Appointment not found for ID: #{params[:id]}"
      flash[:alert] = "Appointment not found."
      redirect_to appointments_path
    end
  end
  

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :date)
  end
end
