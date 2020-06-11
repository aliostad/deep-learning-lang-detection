class RepositoriesController < ApplicationController

  def new
    @repository = Repository.new
    respond_with @repository
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      respond_with @repository, location: repository_commits_path(@repository)
    else
      render :new
    end
  end

  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy
    if first_repo = Repository.first
      redirect_to repository_commits_path(first_repo), :notice => "Repository Removed"
    else
      redirect_to new_repository_path, :notice => "Repository Removed"
    end
  end

  def sync
    @repository = Repository.find(params[:repository_id])
    @repository.sync
    redirect_to repository_commits_path(@repository), :notice => "Repository Synced"
  end
end
