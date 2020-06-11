class Api::V1::RepositoriesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def index
    @repositories = current_user.repositories

    respond_with @repositories
  end

  def show
    @repository = current_user.repositories.where(name: params[:id]).first!

    respond_with @repository
  end

  def create
    @repository = current_user.repositories.new(repository_params)
    @repository.save

    respond_with @repository 
  end

  def update
    @repository = current_user.repositories.where(name: params[:id]).first!
    @repository.update_attributes(repository_params)

    respond_with @repository
  end

  def destroy
    @repository = current_user.repositories.where(name: params[:id]).first!
    @repository.destroy

    respond_with @repository
  end

  private

  def repository_params
    params.require(:repository).permit(:name, :type)
  end
end
