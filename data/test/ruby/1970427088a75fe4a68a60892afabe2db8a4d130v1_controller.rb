class Api::V1Controller < ApiController

   before_filter :authenticate_api_user!

   helper_method :current_api_user
   helper_method :api_user_authenticated?

  private

    def authenticate_api_user!
      unless api_user_authenticated?
        respond_to do |format|
          format.json { head :unauthorized }
        end
      end
    end

    def current_api_user
      if params[:api_token]
        @users = Usuario.where(authentication_token: params[:api_token]).first
      else
        nil
      end
    end


    def api_user_authenticated?
      current_api_user.present?
    end

end
