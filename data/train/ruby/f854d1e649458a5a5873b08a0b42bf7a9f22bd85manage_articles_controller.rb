class ManageArticlesController < ApplicationController
  # GET /manage_articles
  # GET /manage_articles.json
  def index
    @manage_articles = ManageArticle.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manage_articles }
    end
  end

  # GET /manage_articles/1
  # GET /manage_articles/1.json
  def show
    @manage_article = ManageArticle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manage_article }
    end
  end

  # GET /manage_articles/new
  # GET /manage_articles/new.json
  def new
    @manage_article = ManageArticle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manage_article }
    end
  end

  # GET /manage_articles/1/edit
  def edit
    @manage_article = ManageArticle.find(params[:id])
  end

  # POST /manage_articles
  # POST /manage_articles.json
  def create
    @manage_article = ManageArticle.new(params[:manage_article])

    respond_to do |format|
      if @manage_article.save
        format.html { redirect_to @manage_article, notice: 'Manage article was successfully created.' }
        format.json { render json: @manage_article, status: :created, location: @manage_article }
      else
        format.html { render action: "new" }
        format.json { render json: @manage_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manage_articles/1
  # PUT /manage_articles/1.json
  def update
    @manage_article = ManageArticle.find(params[:id])

    respond_to do |format|
      if @manage_article.update_attributes(params[:manage_article])
        format.html { redirect_to @manage_article, notice: 'Manage article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manage_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_articles/1
  # DELETE /manage_articles/1.json
  def destroy
    @manage_article = ManageArticle.find(params[:id])
    @manage_article.destroy

    respond_to do |format|
      format.html { redirect_to manage_articles_url }
      format.json { head :no_content }
    end
  end
end
