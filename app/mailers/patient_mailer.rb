class PatientMailer < ApplicationMailer

  default from: 'saigaikwad936@gmail.com'

  def send_login_details(patient, password)
    @patient = patient
    @password = password
    mail(to: @patient.email, subject: 'Your Account Login Details')
  end
end
