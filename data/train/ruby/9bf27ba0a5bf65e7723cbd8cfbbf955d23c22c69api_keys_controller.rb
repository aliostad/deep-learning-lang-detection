class Users::ApiKeysController < ApplicationController

  before_action :set_user
  before_action :set_api_key, except: %i[index new create]

  respond_to :html

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @api_keys = policy_scope(ApiKey).where(user: @user)
  end

  def new
    @api_key = @user.api_keys.new
    authorize @api_key
    respond_with @api_key
  end

  def create
    @api_key = @user.api_keys.new(api_key_params)
    authorize @api_key
    @api_key.save
    respond_with @api_key, location: -> { user_api_keys_path(@user) }
  end

  def edit
    authorize @api_key
    respond_with @api_key
  end

  def update
    authorize @api_key
    @api_key.update(api_key_params)
    respond_with @api_key, location: -> { user_api_keys_path(@user) }
  end

  def destroy
    authorize @api_key
    @api_key.destroy
    respond_with @api_key, location: -> { user_api_keys_path(@user) }
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_api_key
    @api_key = @user.api_keys.find(params[:id])
  end

  def api_key_params
    params.require(:api_key).permit(*policy(@api_key || ApiKey.new).permitted_attributes)
  end

end
