class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  def show
    @repository = Repository.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  def edit
    @repository = Repository.find(params[:id])
  end

  def create
    @repository = Repository.new(params[:repository])

    respond_to do |format|
      if @repository.save
        flash[:notice] = 'Repository was successfully created.'
        format.html { redirect_to(@repository) }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        flash[:notice] = 'Repository was successfully updated.'
        format.html { redirect_to(@repository) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(repositories_url) }
      format.xml  { head :ok }
    end
  end
end
