class Api::V1::ClassifiedsController < ApplicationController
  # GET /api/v1/classifieds
  # GET /api/v1/classifieds.json
  def index
    @api_v1_classifieds = Api::V1::Classified.all

    render json: @api_v1_classifieds
  end

  # GET /api/v1/classifieds/1
  # GET /api/v1/classifieds/1.json
  def show
    @api_v1_classified = Api::V1::Classified.find(params[:id])

    render json: @api_v1_classified
  end

  # POST /api/v1/classifieds
  # POST /api/v1/classifieds.json
  def create
    @api_v1_classified = Api::V1::Classified.new(api_v1_classified_params)

    if @api_v1_classified.save
      render json: @api_v1_classified, status: :created, location: @api_v1_classified
    else
      render json: @api_v1_classified.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/classifieds/1
  # PATCH/PUT /api/v1/classifieds/1.json
  def update
    @api_v1_classified = Api::V1::Classified.find(params[:id])

    if @api_v1_classified.update(api_v1_classified_params)
      head :no_content
    else
      render json: @api_v1_classified.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/classifieds/1
  # DELETE /api/v1/classifieds/1.json
  def destroy
    @api_v1_classified = Api::V1::Classified.find(params[:id])
    @api_v1_classified.destroy

    head :no_content
  end

  private
    
    def api_v1_classified_params
      params.require(:api_v1_classified).permit(:classified_name, :classified_phone, :classified_description, :classified_exp_date, :classified_categorie)
    end
end
