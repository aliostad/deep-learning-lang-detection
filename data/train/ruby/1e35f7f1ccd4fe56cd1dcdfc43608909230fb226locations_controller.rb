class Api::LocationsController < Api::ApplicationController
  before_action :set_location, only: [:show, :update, :destroy]

  # GET /api/locations
  # GET /api/locations.json
  def index
    @api_locations = current_user.locations
    render json: @api_locations
  end

  # GET /api/locations/1
  # GET /api/locations/1.json
  def show
    render json: @api_location
  end

  # POST /api/locations
  # POST /api/locations.json
  def create
    @api_location = Location.new(location_params)
    @api_location.user = current_user
    if @api_location.save
      render json: @api_location, status: :created, location: api_location_path(@api_location)
    else
      render json: @api_location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/locations/1
  # PATCH/PUT /api/locations/1.json
  def update
    if @api_location.update(location_params)
      head :no_content
    else
      render json: @api_location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/locations/1
  # DELETE /api/locations/1.json
  def destroy
    @api_location.destroy
    head :no_content
  end

  private
  def set_location
    @api_location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end
end