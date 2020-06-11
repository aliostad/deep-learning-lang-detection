class Admin::ApiKeysController < Admin::SharedController
  params_for :api_key, :app_name

  def index    
    @api_keys = ApiKey.page(params[:page])
  end

  def new
    @api_key = ApiKey.new
  end

  def create
    @api_key = ApiKey.new(api_key_params)

    if @api_key.save
      redirect_to admin_api_keys_url, notice: 'La llave se ha creado'
    else
      render action: 'new'
    end
  end

  def edit
    @api_key = ApiKey.find(params[:id])     
  end

  def update
    @api_key = ApiKey.find(params[:id])

    if @api_key.update_attributes(api_key_params)
      redirect_to admin_api_keys_url, notice: 'La llave se ha actualizado'
    else
      render action: 'edit'
    end    
  end


end
