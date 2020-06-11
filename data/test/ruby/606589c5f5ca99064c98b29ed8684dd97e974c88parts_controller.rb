class Api::PartsController < ApiController
  # GET /api/parts
  # GET /api/parts.json
  def index
    @api_parts = Part.all

    render json: @api_parts
  end

  # GET /api/parts/1
  # GET /api/parts/1.json
  def show
    @api_part = Part.find(params[:id])

    render json: @api_part
  end

  # POST /api/parts
  # POST /api/parts.json
  def create
    @api_part = Part.new(params[:api_part])

    if @api_part.save
      render json: @api_part, status: :created, location: @api_part
    else
      render json: @api_part.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/parts/1
  # PATCH/PUT /api/parts/1.json
  def update
    @api_part = Part.find(params[:id])

    if @api_part.update(params[:api_part])
      head :no_content
    else
      render json: @api_part.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/parts/1
  # DELETE /api/parts/1.json
  def destroy
    @api_part = Part.find(params[:id])
    @api_part.destroy

    head :no_content
  end
end
