class Admin::RepositoriesController < AdminAreaController
  
  def index
    @repositories = Repository.find :all
    @repository = Repository.new(params[:repository])
    
    if request.post? && @repository.save
      redirect_to :action => 'index'
    end  
  end
  
  def edit
    @repository = Repository.find(params[:id])
    @repository.attributes = params[:repository]   
    if request.post? && @repository.save
      redirect_to :action => 'index'
    end
  end
  
  def delete
    if request.post?
      @repository = Repository.find(params[:id]) rescue nil
      redirect_to :action => 'index' unless @repository
      @repository.destroy
      redirect_to :action => 'index'
    end
  end
  
  def test_repos # ajax
    r = Repository.new(:name => 'temp', :path => params[:path])
    
    begin
      result = "Success! Youngest revision in this repository is #{r.fs.get_youngest_rev}"
    rescue => e
      logger.debug e
      result = "Failure! Path is not a valid repository"
    end
    render :text => CGI::escapeHTML(result)
  end
end
