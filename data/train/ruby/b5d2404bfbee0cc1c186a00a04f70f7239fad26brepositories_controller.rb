class Admin::RepositoriesController < AdminController
  def index
    @repositories = Repository.all
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
    if @repository.save
      redirect_to [:admin, @repository], notice: 'Repository was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @repository = Repository.find(params[:id])
    if @repository.update_attributes(params[:repository])
      redirect_to [:admin, @repository], notice: 'Repository was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy
    redirect_to admin_repositories_url
  end
end
