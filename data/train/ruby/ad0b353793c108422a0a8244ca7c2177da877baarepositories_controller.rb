class RepositoriesController < ApplicationController
  respond_to :html
  respond_to :json, except: [ :new, :edit ]

  before_filter :authenticate_user!
  before_filter :add_repository_abilities

  def index
    repositories = current_user.repositories.page(params[:page]).per(5)
    @repositories = RepositoryDecorator.decorate(repositories)
    @repository = RepositoryDecorator.decorate(current_user.repositories.build)
    authorize! current_user, :list, @repositories

    respond_with @repositories
  end

  def show
    repository = Repository.find_by_name!(params[:id])
    @repository = RepositoryDecorator.decorate(repository)
    authorize! current_user, :read, @repository

    respond_with @repository
  end

  def new
    @repository = RepositoryDecorator.decorate(current_user.repositories.new)
    authorize! current_user, :create, @repository

    respond_with @repository
  end

  def create
    @repository = RepositoryDecorator.decorate(current_user.repositories.new(repository_params))
    authorize! current_user, :create, @repository
    @repository.save

    respond_with @repository
  end

  def edit
    @repository = RepositoryDecorator.decorate(current_user.repositories.find_by_name!(params[:id]))
    authorize! current_user, :update, @repository

    respond_with @repository
  end

  def update
    @repository = current_user.repositories.find_by_name!(params[:id])
    authorize! current_user, :update, @repository
    @repository.update_attributes(repository_params)

    respond_with @repository, location: repository_url(@repository)
  end

  def destroy
    @repository = current_user.repositories.find_by_name!(params[:id])
    authorize! current_user, :delete, @repository
    @repository.destroy

    respond_with @repository
  end

  private

  def repository_params
    params.require(:repository).permit(:name, :type)
  end

  def add_repository_abilities
    abilities.add_pack! :repository, RepositoryAbilities
    abilities.use_pack :repository
  end
end
