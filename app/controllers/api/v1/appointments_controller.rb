module Api
  module V1
    class AppointmentsController < ApiController
      rescue_from ActiveRecord::RecordInvalid do |e|
        render json: e, status: :unprocessable_entity
      end

      def index
        appointments = if params[:date]
          current_user.appointments_by_date(params[:date])
        else
          current_user.appointments
        end
        render json: appointments
      end

      def create
        appointment = current_user.appointments.pending.create!(appointment_params)
        render json: appointment, status: :created
      end

      private

      def appointment_params
        params
          .require(:appointment)
          .permit(:title, :starts_at)
      end
    end
  end
end
