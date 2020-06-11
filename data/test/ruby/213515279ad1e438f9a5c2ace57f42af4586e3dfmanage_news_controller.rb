class ManageNewsController < ApplicationController
  before_action :set_manage_news, only: [:show, :edit, :update, :destroy]

  # GET /manage_news
  # GET /manage_news.json
  def index
    @manage_news = ManageNews.all
  end

  # GET /manage_news/1
  # GET /manage_news/1.json
  def show
  end

  # GET /manage_news/new
  def new
    @manage_news = ManageNews.new
  end

  # GET /manage_news/1/edit
  def edit
  end

  # POST /manage_news
  # POST /manage_news.json
  def create
    @manage_news = ManageNews.new(manage_news_params)

    respond_to do |format|
      if @manage_news.save
        format.html { redirect_to @manage_news, notice: 'Manage news was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_news }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_news/1
  # PATCH/PUT /manage_news/1.json
  def update
    respond_to do |format|
      if @manage_news.update(manage_news_params)
        format.html { redirect_to @manage_news, notice: 'Manage news was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_news/1
  # DELETE /manage_news/1.json
  def destroy
    @manage_news.destroy
    respond_to do |format|
      format.html { redirect_to manage_news_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_news
      @manage_news = ManageNews.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_news_params
      params.require(:manage_news).permit(:title, :created_by, :news_image, :desc)
    end
end
