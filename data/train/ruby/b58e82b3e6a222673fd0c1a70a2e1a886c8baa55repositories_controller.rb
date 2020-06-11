class RepositoriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @repositories = Repository.all
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      redirect_to repositories_path
    else
    end
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def destroy
    @repository = Repository.find(params[:id])
    @repository.delete
    redirect_to repositories_path
  end
end
