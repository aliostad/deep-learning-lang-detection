class RepositoriesController < ApplicationController
  def show
    @repository = Repository.find params[:id]
    @classes    = @repository.klasses
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Repository not found"
  end

  def create
    @repository = Repository.new repository_params
    respond_to do |format|
      if @repository.save
        @repository.create_build
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
      else
        format.html { render 'new' }
      end
    end
   end

  def new
    @repository = Repository.new
  end

  def index
    # @repositories = Repository.all
    client = Octokit::Client.new \
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    @repositories = client.repositories(current_user.github_username)
  end

  private
  def repository_params
    params.require(:repository).permit(:name)
  end
end