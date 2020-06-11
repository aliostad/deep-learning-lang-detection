class RepositoriesController < BaseAdminController
  before_filter :set_repository, only: [:show, :edit, :update, :destroy, :fetch_branches, :post_hook]
  skip_before_filter :check_user_admin, only: [:fetch_branches]
  skip_before_filter :authenticate_user!, only: [:post_hook]
  skip_before_filter :check_user_admin, only: [:post_hook]
  skip_before_filter :verify_authenticity_token, only: [:post_hook]
  before_filter :authenticate_hook, only: [:post_hook]
  
  # GET /repositories
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  def show
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  def create
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to @repository, notice: 'Repository was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /repositories/1
  def update
    if @repository.update_attributes(repository_params)
      redirect_to @repository, notice: 'Repository was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  # DELETE /repositories/1
  def destroy
    @repository.destroy
    redirect_to repositories_path, notice: "Repository #{@repository.title} was successfully deleted."
  end
  
  # POST /repositories/1/fetch_branches
  def fetch_branches
    @repository.branches true
    if @repository.errors.empty?
      redirect_to :back, notice: 'Branches were successfully updated.'
    else
      redirect_to :back, flash: {error: "Error fetching remote branches: #{@repository.errors.messages[:branches].join(", ")}."}
    end
  end
  
  # POST /repositories/1/post_hook
  def post_hook
    Rails.logger.info "Repository POST hook triggerd"
    if @repository.hook_enabled
      # here we only updating branches list, in future it's a good idea to parse the message body and update specific branches
      FetchBranchesJob.perform_later @repository
    end
    render nothing: true
  end
  
  private
  
    def set_repository
      @repository = Repository.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :path, :vcs_type, :weblink_to_commit, :hook_enabled, :hook_login, :hook_password)
    end
    
    def authenticate_hook
      return true if @repository.hook_login.blank? or @repository.hook_password.blank?
      authenticate_or_request_with_http_basic('Hook') do |username, password|
        username == @repository.hook_login && password == @repository.hook_password
      end
    end
    
end
