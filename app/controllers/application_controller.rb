class ApplicationController < ActionController::API
    include CanCan::ControllerAdditions
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    respond_to :json
    private

    def current_ability
      unless @current_ability.present?
        @current_ability = Ability.new(current_user)      
      end
  
      @current_ability
    end

    def handle_not_found(error)
        render json: { error: error.message }, status: :not_found
      end
    
      def handle_error(error)
        render json: { error: error.message }, status: error.status
      end
    
      def authenticate_user
        authenticate_user!
      end
    # def configure_permitted_parameters
    #     devise_parameter_sanitizer.permit(:sign_up)
    # end

    # def authenticate_user
    #     if request.headers['Authorization'].present?
    #       authenticate_or_request_with_http_token do |token|
    #         begin
    #           jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
    
    #           @current_user_id = jwt_payload['id']
    #         rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    #           head :unauthorized
    #         end
    #       end
    #     end
    #   end

    #   def current_user
    #     @current_user ||= super || User.find(@current_user_id)
    #   end
    
    #   def signed_in?
    #     @current_user_id.present?
    #   end
end
