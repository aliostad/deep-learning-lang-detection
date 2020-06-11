class RepositoriesController < ApplicationController
  before_filter :authenticate_user!, except: [:build_latest]

  protect_from_forgery except: [:build_latest]
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show

  end

  def build_latest
    if user_signed_in?
      @repository = current_user.repositories.find(params[:id])
    else
      @repository = Repository.find(params[:id])
      if params[:token] != @repository.build_token
        render status: 401, text: {error: 'token invalid'}
        return
      end
    end
    if @repository.is_external?
      build = @repository.build_external
    else
      build = @repository.build_from_last_commit
    end
    render json: build
  end

  def summary
    @repository = current_user.repositories.find(params[:id])
    render json: @repository.build_summary
  end

  # GET /repositories/new
  def new
    load_repos
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(repository_params.merge(user: current_user))
    @repository.full_name ||= @repository.name
    if @repository.save
      @repository.add_hook if @repository.needs_hook?
      redirect_to results_overview_index_path(repository_id: @repository.id), notice: 'Repository was successfully created.'
    else
      load_repos
      render 'new'
    end
  end

  # PATCH/PUT /repositories/1
  def update
    if @repository.update(repository_params)
      redirect_to results_overview_index_path(repository_id: @repository.id), notice: 'Repository was successfully updated.'
    else
      render 'edit'
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    redirect_to results_overview_index_path
  end

  private

    def load_repos
      @repositories = current_user.github_client.repos
      @current_repositories = current_user.repositories
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:name, :full_name, :url, :repository_type, :github_id, :config)
    end

end
