class AppointmentsController < ApplicationController
  def index
    t = Time.current
    @upcoming = Appointment.upcoming(t)
    @past = Appointment.past(t)
    @pending = Appointment.relevant_pending(t)
    @canceled = Appointment.canceled_or_obsolete(t)
  end

  def edit
    @appointment = Appointment.find(params[:id])
  end

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.create(appointment_params)
    respond_with @appointment
  end

  def update
    @appointment = Appointment.find(params[:id])
    @appointment.update(appointment_params)
    respond_with @appointment
  end

  private

  def appointment_params
    params
      .require(:appointment)
      .permit(:title, :starts_at)
  end
end
