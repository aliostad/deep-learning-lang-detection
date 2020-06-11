class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])

    if @repository.save
      begin
        Repository.load(@repository.path)
        flash[:success] = "#{@repository.path} has been successfully loaded."
        redirect_to repositories_path and return
      rescue => e
        flash[:error] = "#{@repository.path} does not exist."
        @repository.delete
      end
    end
    render :new
  end
end
