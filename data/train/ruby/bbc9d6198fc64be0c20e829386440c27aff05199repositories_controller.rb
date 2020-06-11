class RepositoriesController < ApplicationController

  def index
    @repositories = Repository.paginate :per_page => 20, :page => params[:page],
      :order => 'name'
    redirect_to(setup_repositories_path) if @repositories.empty?
  end
  
  def setup
  end

  def show
    @repository = Repository.find(params[:id])
  end
  
  def new
    @repository = Repository.new
  end
  
  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      @repository.identify!
      redirect_to @repository
    else
      render :action => 'new'
    end
  end
  
  # def edit
  #   @repository = repository.find(params[:id])
  # end
  
  def update
    @repository = Repository.find(params[:id])
    @repository.identify!
    redirect_to @repository
  end

  # def destroy
  #   @repository = repository.find(params[:id])
  #   @repository.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(repositorys_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
  def import
    Harvester.harvest_registered_repositories
    redirect_to repositories_path
  end

end
