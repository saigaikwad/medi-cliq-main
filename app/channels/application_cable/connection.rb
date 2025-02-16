module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_patient

    def connect
      self.current_patient = find_verified_patient
      logger.add_tags 'ActionCable', current_patient.email
    end

    private

    def find_verified_patient
      if verified_patient = env['warden'].user(:patient)
        verified_patient
      else
        reject_unauthorized_connection
      end
    end
  end
end
