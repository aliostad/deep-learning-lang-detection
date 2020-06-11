class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  def index
    @repositories = Repository.all
  end

  def show
  end

  def new
    @repository = Repository.new

    github = Github.new oauth_token: session[:github_token]
    connected = !!session[:github_token]

    @github_auth_url = github.authorize_url redirect_uri: 'http://localhost:3000/callback/github?from=new', scope: 'repo'
    @repos = github.repos.list if connected

  end

  def edit
  end

  def create
    @repository = Repository.new(repository_params)

    if @repository.save
      redirect_to @repository, notice: 'Repository was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @repository.update(repository_params)
      redirect_to @repository, notice: 'Repository was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @repository.destroy
    redirect_to repositories_url, notice: 'Repository was successfully destroyed.'
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
    end

    def repository_params
      params.require(:repository).permit(:name, :repo_uri, :docker_uri)
    end
end
