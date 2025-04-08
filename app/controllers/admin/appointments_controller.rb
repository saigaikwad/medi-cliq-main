module Admin
  class AppointmentsController < ::AppointmentsController
    before_action :authenticate_admin!
  end
end
