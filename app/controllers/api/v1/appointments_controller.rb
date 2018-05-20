module Api
  module V1
    class AppointmentsController < ApiController
      def index
        appointments = if params[:date] 
          current_user.appointments_by_date(params[:date])
        else
          current_user.appointments
        end
        render json: appointments
      end

      def create
      end
    end
  end
end
