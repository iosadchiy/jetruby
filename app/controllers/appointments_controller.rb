class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
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
