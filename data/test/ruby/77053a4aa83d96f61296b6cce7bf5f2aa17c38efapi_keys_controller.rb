class Admin::ApiKeysController < Admin::AdminController
  before_action :initialize_permissions, only: [:new, :edit, :update]

  def index
    @api_keys = ApiKey.all
  end

  def new
    @api_key = ApiKey.new
  end

  def create
    @api_key = ApiKey.new(api_key_attributes)
    if @api_key.save
      redirect_to admin_api_keys_path
    else
      render :new
    end
  end

  def update
    @api_key = ApiKey.find(params[:id])

    if @api_key.update_attributes(api_key_attributes)
      redirect_to admin_api_keys_path
    else
      render :edit
    end
  end

  def edit
    @api_key = ApiKey.find(params[:id])
  end

  def destroy
    ApiKey.destroy(params[:id])
    redirect_to admin_api_keys_path
  end

  def show
    @api_key = ApiKey.find params[:id]
  end

  private

  def api_key_attributes
    params.require(:api_key).permit(:name, :key, permissions: [])
  end

  def initialize_permissions
    @permissions = Rails.application.routes.named_routes.routes.values.select { |node| node.name[/(?=api)(?!api_key)/] }.map(&:name)
  end
end
