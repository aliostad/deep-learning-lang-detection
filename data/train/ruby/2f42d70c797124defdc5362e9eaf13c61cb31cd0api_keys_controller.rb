class Admin::ApiKeysController < AdminController
  before_action :set_api_key, only: [:update, :destroy]
  authorize_resource
  # GET /api_keys
  def index
    @api_keys = ApiKey.accessible_by(current_ability)
  end

  # GET /api_keys/new
  def new
    @api_key = ApiKey.new
  end

  # POST /api_keys
  def create
    @api_key = ApiKey.new(api_key_params.merge(token: ApiKey.generate_token))

    if @api_key.save
      redirect_to admin_api_keys_path, notice: 'Api key was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /api_keys/1
  def update
    if @api_key.update(token: ApiKey.generate_token)
      redirect_to admin_api_keys_path, notice: 'Api key was successfully updated.'
    else
      redirect_to admin_api_keys_path, notice: 'Api key was unable to be updated'
    end
  end

  # DELETE /api_keys/1
  def destroy
    @api_key.destroy
    redirect_to admin_api_keys_url, notice: 'Api key was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def api_key_params
      params.require(:api_key).permit(:name, :enabled)
    end
end
