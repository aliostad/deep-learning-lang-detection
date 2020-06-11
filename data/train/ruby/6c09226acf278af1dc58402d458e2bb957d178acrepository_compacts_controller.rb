class RepositoryCompactsController < ApplicationController
  # GET /repository_compacts
  # GET /repository_compacts.json
  def index
    @repository_compacts = RepositoryCompact.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repository_compacts }
    end
  end

  # GET /repository_compacts/1
  # GET /repository_compacts/1.json
  def show
    @repository_compact = RepositoryCompact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository_compact }
    end
  end

  # GET /repository_compacts/new
  # GET /repository_compacts/new.json
  def new
    @repository_compact = RepositoryCompact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repository_compact }
    end
  end

  # GET /repository_compacts/1/edit
  def edit
    @repository_compact = RepositoryCompact.find(params[:id])
  end

  # POST /repository_compacts
  # POST /repository_compacts.json
  def create
    @repository_compact = RepositoryCompact.new(params[:repository_compact])

    respond_to do |format|
      if @repository_compact.save
        format.html { redirect_to @repository_compact, notice: 'Repository compact was successfully created.' }
        format.json { render json: @repository_compact, status: :created, location: @repository_compact }
      else
        format.html { render action: "new" }
        format.json { render json: @repository_compact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /repository_compacts/1
  # PUT /repository_compacts/1.json
  def update
    @repository_compact = RepositoryCompact.find(params[:id])

    respond_to do |format|
      if @repository_compact.update_attributes(params[:repository_compact])
        format.html { redirect_to @repository_compact, notice: 'Repository compact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repository_compact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repository_compacts/1
  # DELETE /repository_compacts/1.json
  def destroy
    @repository_compact = RepositoryCompact.find(params[:id])
    @repository_compact.destroy

    respond_to do |format|
      format.html { redirect_to repository_compacts_url }
      format.json { head :no_content }
    end
  end
end
