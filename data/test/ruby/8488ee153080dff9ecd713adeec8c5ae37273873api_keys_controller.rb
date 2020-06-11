class ApiKeysController < ApplicationController
  # GET /api_keys
  # GET /api_keys.json
  def index
    @api_keys = ApiKey.all

    render json: @api_keys
  end

  # GET /api_keys/1
  # GET /api_keys/1.json
  def show
    @api_key = ApiKey.find(params[:id])

    render json: @api_key
  end

  # POST /api_keys
  # POST /api_keys.json
  def create
    @api_key = ApiKey.new(params[:api_key])

    if @api_key.save
      render json: @api_key, status: :created, location: @api_key
    else
      render json: @api_key.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api_keys/1
  # PATCH/PUT /api_keys/1.json
  def update
    @api_key = ApiKey.find(params[:id])

    if @api_key.update(params[:api_key])
      head :no_content
    else
      render json: @api_key.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api_keys/1
  # DELETE /api_keys/1.json
  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.destroy

    head :no_content
  end
end
