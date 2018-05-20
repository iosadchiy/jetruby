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
        @current_user ||= User.from_authorization_header(request.headers['Authorization'])
      end
    end
  end
end
