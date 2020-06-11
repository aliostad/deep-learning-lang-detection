module Admin

  class ChunksController < AdminController

    layout 'top'

    before_filter :find_section

    def show
      @chunk = Chunk.find(params[:id])
      render :template => 'admin/site_page_view', :locals => { :partial => 'admin/chunks/show' }
    end

    def new
      @chunk = Chunk.new
      render :template => 'admin/site_page_edit', :locals => { :partial => 'admin/chunks/new' }
    end

    def create
      @chunk = Chunk.new(params[:chunk])

      if @section.chunks << @chunk
        redirect_to admin_section_chunk_path(@section, @chunk)
      else
        flash.now[:error] = 'Error creating Chunk.'
        render :template => 'admin/site_page_edit', :locals => { :partial => 'admin/chunks/new' }
      end
    end

    def edit
      @chunk = Chunk.find(params[:id])
      render :template => 'admin/site_page_edit', :locals => { :partial => 'admin/chunks/edit' }
    end

    def update
      @chunk = Chunk.find(params[:id])

      if @chunk.update_attributes(params[:chunk])
        redirect_to admin_section_chunk_path(@section, @chunk)
      else
        flash.now[:error] = 'Error updating Chunk.'
        render :template => 'admin/site_page_edit', :locals => { :partial => 'admin/chunks/edit' }
      end
    end

    def destroy
      @chunk = Chunk.find(params[:id])

      if @chunk.destroy
        redirect_to admin_section_path(@section)
      else
        flash.now[:error] = 'Error deleting Chunk.'
        render :template => 'admin/site_page_view', :locals => { :partial => 'admin/chunks/show' }
      end
    end

    private

    def find_section
      @section_id = params[:section_id]
      return(redirect_to(admin_sections_url)) unless @section_id
      @section = Section.find(@section_id)
    end
  end
end
