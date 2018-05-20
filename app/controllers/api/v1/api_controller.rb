module Api
  module V1
    class ApiController < ActionController::API
      before_action :authenticate!

      def authenticate!
        unless current_user
          render json: {error: "Not authenticated"}, status: :unauthorized
        end
      end

      def current_user
        @current_user ||= if request.headers['Authorization'] =~ /^Token token=(.*)$/
          User.find_by(api_key: $1)
        end
      end
    end
  end
end
