class Api::V1::CategoriesController < ApplicationController
  # GET /api/v1/categories
  # GET /api/v1/categories.json
  def index
    @api_v1_categories = Api::V1::Categorie.all

    render json: @api_v1_categories
  end

  # GET /api/v1/categories/1
  # GET /api/v1/categories/1.json
  def show
    @api_v1_category = Api::V1::Categorie.find(params[:id])

    render json: @api_v1_category
  end

  # POST /api/v1/categories
  # POST /api/v1/categories.json
  def create
    @api_v1_category = Api::V1::Categorie.new(api_v1_category_params)

    if @api_v1_category.save
      render json: @api_v1_category, status: :created, location: @api_v1_category
    else
      render json: @api_v1_category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/categories/1
  # PATCH/PUT /api/v1/categories/1.json
  def update
    @api_v1_category = Api::V1::Categorie.find(params[:id])

    if @api_v1_category.update(api_v1_category_params)
      head :no_content
    else
      render json: @api_v1_category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/categories/1
  # DELETE /api/v1/categories/1.json
  def destroy
    @api_v1_category = Api::V1::Categorie.find(params[:id])
    @api_v1_category.destroy

    head :no_content
  end

  private
    
    def api_v1_category_params
      params.require(:api_v1_category).permit(:categorie_name)
    end
end
