class ApplicationController < ActionController::Base
  def index
    @appointments = Appointment.all
  end
end
