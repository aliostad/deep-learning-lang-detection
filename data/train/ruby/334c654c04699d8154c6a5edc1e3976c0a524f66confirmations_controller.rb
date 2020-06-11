class ConfirmationsController < Devise::ConfirmationsController
  def show
    @api_user = Api::User.find_by_confirmation_token(params[:confirmation_token])
    unless @api_user.present?
      redirect_to root_path
    end
  end

  def confirm_account
    @api_user = Api::User.find_by_confirmation_token(params[:api_user][:confirmation_token])
    if @api_user.update_attributes(params[:api_user])
      @api_user = Api::User.confirm_by_token(@api_user.confirmation_token)
      set_flash_message :notice, :confirmed
      redirect_to root_path
    else
      render :action => "show"
    end
  end

end