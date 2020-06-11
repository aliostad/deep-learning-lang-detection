class Manage::PagesController < Manage::BaseController
  before_filter :find_structure
  before_filter :find_page
  
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  
  authorize_resource
  
  # GET /manage/structures/1/page/edit
  def edit
    respond_with(@page) do |format|
      format.html { render :action => (@page.new_record? ? 'new' : 'edit') }
    end
  end
  
  # POST /manage/structures/1/page
  def create
    @page.update_attributes(params[:page])
    respond_with(@page, :location => manage_structures_path)
  end
  
  # PUT /manage/structures/1/page
  def update
    @page.update_attributes(params[:page])
    respond_with(@page, :location => manage_structures_path)
  end
  
  protected
  
    def find_structure
      @structure = Structure.find(params[:structure_id])
    end
    
    def find_page
      @page = @structure.page || @structure.build_page(:title => @structure.title)
    end
end
