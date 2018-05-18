class AppointmentsController < ApplicationController
  def index
    t = Time.current
    @upcoming = appointments.upcoming_confirmed(t)
    @past = appointments.past(t)
    @pending = appointments.relevant_pending(t)
    @canceled = appointments.canceled_or_obsolete(t)
  end

  def edit
    @appointment = appointments.find(params[:id])
  end

  def new
    @appointment = appointments.new
  end

  def create
    @appointment = current_user.appointments.confirmed.create(appointment_params)
    respond_with @appointment
  end

  def update
    @appointment = appointments.find(params[:id])
    @appointment.update(appointment_params)
    respond_with @appointment
  end

  private

  def appointments
    current_user.appointments
  end

  def appointment_params
    params
      .require(:appointment)
      .permit(:title, :starts_at)
  end
end
