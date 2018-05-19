class AppointmentsController < ApplicationController
  def index
    t = Time.current
    @upcoming = appointments.upcoming_confirmed(t)
    @past = appointments.past_confirmed(t)
    @pending = appointments.relevant_pending(t)
    @canceled = appointments.canceled_or_obsolete(t)
  end

  def edit
    @appointment = find_appointment
    @appointment.build_nested
  end

  def new
    @appointment = appointments.new
    @appointment.build_nested
  end

  def create
    @appointment = current_user.appointments.confirmed.create(appointment_params)
    respond_with @appointment
  end

  def update
    @appointment = find_appointment
    @appointment.update(appointment_params)
    respond_with @appointment
  end

  def confirm
    @appointment = find_appointment
    @appointment.confirmed!
    respond_with @appointment
  end

  def cancel
    @appointment = find_appointment
    @appointment.canceled!
    respond_with @appointment
  end

  private

  def appointments
    current_user.appointments
  end

  def find_appointment
    appointments.find(params[:id])
  end

  def appointment_params
    params
      .require(:appointment)
      .permit(
        :title,
        :starts_at,
        :state,
        reminders_attributes: [:id, :minutes_before, :_destroy]
      )
  end
end
