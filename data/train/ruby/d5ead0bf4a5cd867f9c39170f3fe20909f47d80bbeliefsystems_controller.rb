class Api::V1::BeliefsystemsController < ApplicationController
  # GET /api/v1/beliefsystems
  # GET /api/v1/beliefsystems.json
  def index
    @api_v1_beliefsystems = Api::V1::Beliefsystem.all

    render json: @api_v1_beliefsystems, root: 'beliefsystems', each_serializer: Api::V1::BeliefsystemSerializer 
  end

  # GET /api/v1/beliefsystems/1
  # GET /api/v1/beliefsystems/1.json
  def show
    @api_v1_beliefsystem = Api::V1::Beliefsystem.find(params[:id])

    render json: @api_v1_beliefsystem, root: 'beliefsystem'
    # , serializer: Api::V1::SingleBoardSerializer 

  end

  # POST /api/v1/beliefsystems
  # POST /api/v1/beliefsystems.json
  def create
    @api_v1_beliefsystem = Api::V1::Beliefsystem.new(params[:beliefsystem])

    if @api_v1_beliefsystem.save
      render json: @api_v1_beliefsystem, status: :created, root: 'beliefsystem', location: @api_v1_beliefsystem
    else
      render json: @api_v1_beliefsystem.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/beliefsystems/1
  # PATCH/PUT /api/v1/beliefsystems/1.json
  def update
    @api_v1_beliefsystem = Api::V1::Beliefsystem.find(params[:id])

    if @api_v1_beliefsystem.update_attributes(params[:beliefsystem])
      head :no_content
    else
      render json: @api_v1_beliefsystem.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/beliefsystems/1
  # DELETE /api/v1/beliefsystems/1.json
  def destroy
    @api_v1_beliefsystem = Api::V1::Beliefsystem.find(params[:id])
    @api_v1_beliefsystem.destroy

    head :no_content
  end
end
