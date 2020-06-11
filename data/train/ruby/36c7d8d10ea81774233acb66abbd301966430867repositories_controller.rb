class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :update, :destroy]

  # GET /repositories
  def index
    @repositories = Repository.all

    render json: @repositories
  end

  # GET /repositories/1
  def show
    render json: @repository
  end

  # POST /repositories
  def create
    @repository = Repository.new(repository_params)

    if @repository.save
      render json: @repository, status: :created, location: @repository
    else
      render json: @repository.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /repositories/1
  def update
    if @repository.update(repository_params)
      render json: @repository
    else
      render json: @repository.errors, status: :unprocessable_entity
    end
  end

  # DELETE /repositories/1
  def destroy
    @repository.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def repository_params
      params.require(:repository).permit(:name, :short_name, :download_url)
    end
end
