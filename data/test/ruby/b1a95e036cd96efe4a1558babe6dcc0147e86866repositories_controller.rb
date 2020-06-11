class Admin::RepositoriesController < Admin::BaseController
  current_tab(:major, :repositories)
  current_tab(:minor, :detail, :only => [:edit, :update])

  helper('admin/repository_tabs', :repositories)

  def index
    @repositories = Repository.find_by_space_name(params[:space])
  end
  
  def new
    @repository = Repository.new
  end
  
  def create
    @repository = Repository.new(repo_params)
    if @repository.save
      flash[:success] = msg_created(@repository)
      redirect_to(edit_admin_repository_path(@repository))
    else
      render('new')
    end
  end
  
  def edit
  end

  def update
    repository.attributes = repo_params

    if repository.valid? && Repository.confirmation_required?(repository)
      render('confirm_update')
    elsif repository.save
      flash[:success] = msg_updated(repository)
      redirect_to(edit_admin_repository_path(repository))
    else
      render("edit")
    end
  end

  def confirm_update
    repository.update_attributes(repo_params)

    if params[:perform_notification]
      msg = RepositoryUrlChangedMessage.new_from_repository_params(current_user, params[:repo_changed])
      CollaboratorMailer.deliver_repository_url_changed_notification(msg)
    end

    flash[:success] = msg_updated(repository)
    redirect_to(edit_admin_repository_path(repository))
  end

  def destroy
    repository.destroy
    flash[:success] = msg_destroyed(repository)
    redirect_to(admin_repositories_path)
  end

  def create_svn_directory
    if !repository.svn_dir_exists?
      repository.create_svn_repository
      flash[:success] = "SVN Directory has been created."
    end
    redirect_to(edit_admin_repository_path(repository))
  end

  protected

  def repo_params
    params.require(:repository).permit!
  end

  def repositories
    @repositories
  end
  helper_method :repositories

  def repository
    @repository ||= Repository.find(params[:id])
  end
  helper_method :repository

  def spaces
    @spaces ||= Space.all.inject({}) do |hash, space|
      hash[space.name] = space.id
      hash
    end
  end
  helper_method :spaces
end
