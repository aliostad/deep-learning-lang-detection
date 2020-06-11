class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all.select { |repo| can? :view, repo }
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    access_denied! 'cannot.view.repository', repositories_path if cannot? :view, @repository
  end

  # GET /repositories/new
  def new
    access_denied! 'cannot.create.repository', repositories_path if cannot? :create, Repository
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
    access_denied! 'cannot.edit.repository', repositories_path if cannot? :edit, @repository
  end

  # POST /repositories
  # POST /repositories.json
  def create
    access_denied! 'cannot.create.repository', repositories_path if cannot? :create, Repository

    @repository = Repository.new(repository_params)
    access_denied! 'cannot.edit.repository', repositories_path if cannot? :edit, @repository

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render action: 'show', status: :created, location: @repository }
      else
        format.html { render action: 'new' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  def update
    access_denied! 'cannot.edit.repository', repositories_path if cannot? :edit, @repository

    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    access_denied! 'cannot.delete.repository', repositories_path if cannot? :delete, @repository

    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def repository_params
    params.require(:repository).permit(:name, :user_id)
  end
end
