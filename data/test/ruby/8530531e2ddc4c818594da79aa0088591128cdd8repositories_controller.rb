class RepositoriesController < ApplicationController

  tab :repositories

  def index
    @repositories = Repository.all
  end

  def show
    repository = Repository.find_by_name!(params[:id])
    redirect_to repository_commit_files_path(repository, 'master')
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      flash[:success] = 'Repository created.'
      redirect_to repositories_path
    else
      render :edit
    end
  end

  def edit
    @repository = Repository.find_by_name!(params[:id])
  end

  def update
    @repository = Repository.find_by_name!(params[:id])
    if @repository.update_attributes(params[:repository])
      flash[:success] = 'Repository updated.'
      redirect_to repositories_path
    else
      render :edit
    end
  end

end
