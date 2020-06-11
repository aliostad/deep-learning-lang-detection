class ApiUsersController < ApplicationController
  def index
  end

  def new
    @api_user = ApiUser.new
  end

  def create
  @api_user = ApiUser.new(params[:api_user])
  @api_user.api_key = Digest::SHA1.hexdigest(@api_user.email)
    if @api_user.save
      flash[:notice] = "Successfully created account! Please check your email for a verification link."
      Verifier.deliver_signup_notification(@api_user)
      redirect_to :login
    else
      render :action => 'new'
    end
  end

  def show
    @api_user = ApiUser.find(current_api_user)
  end

  def edit
    @api_user = ApiUser.find(current_api_user)
  end
  
  def update
    @api_user = ApiUser.find(current_api_user)
        @api_user.first_name = params[:api_user][:first_name]
        @api_user.last_name = params[:api_user][:last_name]    
        @api_user.email = params[:api_user][:email]
        if !params[:api_user][:password].empty?
          @api_user.password = params[:api_user][:password]
          @api_user.password_confirmation = params[:api_user][:password]
        end
        if @api_user.save
          flash[:notice] = "Successfully saved your information."
          redirect_to @api_user
        else
          flash[:error] = "There was an error."
          render :action => "edit"
        end
  end

  def regenerate_key
    @api_user = ApiUser.find(current_api_user)
    @api_user.api_key = Digest::SHA1.hexdigest(@api_user.email + Time.now.to_s)
    @api_user.save
    redirect_to :action => "show"
  end
  
  def validate_new_user
    if !ApiUser.exists?(:perishable_token => params[:id])
      flash[:error] = "Error verifying account: No user found with that verification code."
      redirect_to :login
      return false
    end
    
    @api_user = ApiUser.find_using_perishable_token!(params[:id])
      Verifier.deliver_verified_notification(@api_user)
    @api_user.active = true # make the user active!
    if @api_user.save
      flash[:notice] = "Your account has been verified! Please log in below."
    else
      flash[:error] = "There was an error verifying your account."
    end
    redirect_to :login
  end
end
