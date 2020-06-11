class Admin::RepositoriesController < Admin::AdminController
  load_and_authorize_resource :except => [:index, :new, :create]

  include Params::RepoParams

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    redirect_to [@repository.owner, @repository]
  end

  # GET /repositories/new
  # GET /repositories/new.json
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repository }
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.json
  def update
    respond_to do |format|
      if @repository.update_attributes(repo_params)
        format.html { redirect_to [@repository.owner, @repository], notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
        format.js { flash[:notice] = 'Repository was updated.'}
      else
        flash_save_errors "repository", @repository.errors
        format.html { render action: "edit" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    @repository = Repository.find(params[:repository_id])
    if @repository.repository.valid?
      respond_to do |format|
        if @repository.archive
          format.html { redirect_to action: 'index', notice: 'Repository was archived.'}
        else
          format.html {redirect_to action: 'index', notice: 'Repository could not not be archived.'}
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to action: 'index', notice: "Repository #{@repository.name} not valid."}
      end
    end
  end
  
  def unarchive
    @repository = Repository.find(params[:repository_id])
    
    respond_to do |format|
      if @repository.unarchive
        format.html { redirect_to action: 'index', notice: 'Repository was restored.'}
      else
        format.html { redirect_to action: 'index', notice: 'Repository could not be restored.'}
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to admin_repositories_url, notice: "Repository #{@repository.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end
end
