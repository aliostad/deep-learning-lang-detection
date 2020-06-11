# TODO colocar permissões
class Admin::Projects::RepositoriesController < ApplicationController
  before_filter :authenticate!, :only_admin!

  helper_method :current_project

  def index
    @repositories = current_project.repositories
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def new
    @repository = Repository.new
  end

  def edit
    @repository = Repository.find(params[:id])
  end

  def create
    @repository = Repository.new(params[:repository])
    @repository.project = current_project

    if @repository.save
      log current_user, "Criou o reposiotio #{@repository.name} no projeto #{current_project.name}"
      redirect_to [:admin, current_project, @repository], notice: 'Repository was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @repository = Repository.find(params[:id])

    if @repository.update_attributes(params[:repository])
      log current_user, "Alterou o reposiotio #{@repository.name} no projeto #{current_project.name}"
      redirect_to [:admin, current_project, @repository], notice: 'Repository was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    log current_user, "Removeu o reposiotio #{@repository.name} no projeto #{current_project.name}"

    redirect_to admin_project_repositories_url(current_project)
  end

  private
  def current_project
    @current_project ||= ::Project.find(params[:project_id])
  end
end
