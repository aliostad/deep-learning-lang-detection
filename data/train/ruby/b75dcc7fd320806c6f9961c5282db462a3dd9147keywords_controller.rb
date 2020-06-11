class Api::KeywordsController < ApplicationController
  before_action :set_api_keyword, only: [:show, :update, :destroy]

  # GET /api/keywords
  # GET /api/keywords.json
  def index
    @api_keywords = Api::Keyword.all
  end

  # GET /api/keywords/1
  # GET /api/keywords/1.json
  def show
  end

  # POST /api/keywords
  # POST /api/keywords.json
  def create
    @api_keyword = Api::Keyword.new(api_keyword_params)
    @api_keyword.groups = @api_keyword.groups.split(",") unless api_keyword_params[:groups].blank?

    if @api_keyword.save
      render :show, status: :created, location: @api_keyword
    else
      render json: @api_keyword.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/keywords/1
  # PATCH/PUT /api/keywords/1.json
  def update
    if @api_keyword.update(api_keyword_params)
      render :show, status: :ok, location: @api_keyword
    else
      render json: @api_keyword.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/keywords/1
  # DELETE /api/keywords/1.json
  def destroy
    @api_keyword.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_keyword
      @api_keyword = Api::Keyword.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_keyword_params
      params.require(:api_keyword).permit(:name, :groups)
    end
end
