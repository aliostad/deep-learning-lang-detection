class RepositoriesController < ApplicationController
  before_filter :set_repository, only: [:show, :edit, :update, :destroy]

  def index
    @repositories = Repository.all
    respond_with(@repositories)
  end

  def show
    respond_with(@repository)
  end

  def new
    @repository = Repository.new
    respond_with(@repository)
  end

  def edit
  end

  def create
    @repository = Repository.new(params[:repository])
    @repository.save
    respond_with(@repository)
  end

  def update
    @repository.update_attributes(params[:repository])
    respond_with(@repository)
  end

  def destroy
    @repository.destroy
    respond_with(@repository)
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
    end
end
