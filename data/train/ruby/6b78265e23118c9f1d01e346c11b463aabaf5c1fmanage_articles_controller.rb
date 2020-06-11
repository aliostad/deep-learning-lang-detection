class ManageArticlesController < ApplicationController
  before_action :set_manage_article, only: [:show, :edit, :update, :destroy]

  # GET /manage_articles
  # GET /manage_articles.json
  def index
    @manage_articles = ManageArticle.all
  end

  # GET /manage_articles/1
  # GET /manage_articles/1.json
  def show
  end

  # GET /manage_articles/new
  def new
    @manage_article = ManageArticle.new
  end

  # GET /manage_articles/1/edit
  def edit
  end

  # POST /manage_articles
  # POST /manage_articles.json
  def create
    @manage_article = ManageArticle.new(manage_article_params)

    respond_to do |format|
      if @manage_article.save
        format.html { redirect_to @manage_article, notice: 'Manage article was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_article }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_articles/1
  # PATCH/PUT /manage_articles/1.json
  def update
    respond_to do |format|
      if @manage_article.update(manage_article_params)
        format.html { redirect_to @manage_article, notice: 'Manage article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_articles/1
  # DELETE /manage_articles/1.json
  def destroy
    @manage_article.destroy
    respond_to do |format|
      format.html { redirect_to manage_articles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_article
      @manage_article = ManageArticle.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_article_params
      params.require(:manage_article).permit(:title, :cat, :sub_cat, :image, :created_by, :rel_article, :desc)
    end
end
