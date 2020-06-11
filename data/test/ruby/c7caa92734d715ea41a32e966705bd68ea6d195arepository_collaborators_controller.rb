class Admin::RepositoryCollaboratorsController < Admin::BaseController
  before_filter(:repository)
  before_filter(:permissions)

  current_tab(:major, :repositories)
  current_tab(:minor, :collaborators)

  helper('admin/repository_tabs')
  # helper('repository_collaborators')
  helper('repositories')


  def index
    @collaborations = repository.collaborations
    @administrators = repository.administrators
  end

  def edit
    @users = repository.collaborators_available
    @administrators = repository.administrators
  end

  def update
    repository.update_collaborators_from_params(current_user, params)
    flash[:notice] = msg_updated("Collaborators")
    redirect_to(admin_repository_collaboration_url(repository, :id => ''))
  end

  
  protected

  def permissions
    @permissions = Collaboration.permissions
    @permissions.unshift("")
  end
  helper_method :permissions

  def repository
    @repository ||= Repository.find(params[:repository_id])
  end
  helper_method :repository

  def administrators
    @administrators
  end
  helper_method :administrators

  def collaborations
    @collaborations
  end
  helper_method :collaborations

  def users
    @users ||= User.all
  end
  helper_method :users
end
