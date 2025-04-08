module Admin
  class PrescriptionsController < ::PrescriptionsController
    before_action :authenticate_admin!
  end
end
