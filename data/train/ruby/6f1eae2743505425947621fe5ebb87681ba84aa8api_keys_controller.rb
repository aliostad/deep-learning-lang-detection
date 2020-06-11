class ApiKeysController < ApplicationController
  before_action :set_api_key, only: [:update, :destroy]

  # GET /api_keys
  # GET /api_keys.json
  def index
    @api_keys = ApiKey.all
  end

  # POST /api_keys
  # POST /api_keys.json
  def create
    @api_key = ApiKey.new(api_key_params)

    respond_to do |format|
      if @api_key.save
        format.html { redirect_to api_keys_url, notice: 'API Key was successfully created.' }
        format.json { render :show, status: :created, location: @api_key }
      else
        format.html { render :new }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_keys/1
  # PATCH/PUT /api_keys/1.json
  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        format.html { redirect_to api_keys_url, notice: 'API Key was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_key }
      else
        format.html { render :edit }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_keys/1
  # DELETE /api_keys/1.json
  def destroy
    @api_key.destroy
    respond_to do |format|
      format.html { redirect_to api_keys_url, notice: 'API Key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_api_key
    @api_key = ApiKey.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def api_key_params
    params[:api_key]
  end
end
