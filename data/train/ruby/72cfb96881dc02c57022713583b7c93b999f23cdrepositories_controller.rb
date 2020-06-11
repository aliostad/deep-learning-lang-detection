class RepositoriesController < ApplicationController
  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    @repository = Repository.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/new
  # GET /repositories/new.json
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(params[:repository])

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render json: @repository, status: :created, location: @repository }
      else
        format.html { render action: "new" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.json
  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to repositories_url }
      format.json { head :no_content }
    end
  end
end
