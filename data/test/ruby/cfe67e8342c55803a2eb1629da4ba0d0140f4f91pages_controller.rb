module Manage
  class PagesController < Manage::ManageController
    respond_to :html
    respond_to :json, only: [ :preview ]
    
    expose( :pages ) { current_frame.pages }
    expose( :page )
    
    def create
      flash[ :notice ] = "Page: #{ page.title } was successfully created." if page.save
      respond_with :manage, page, location: manage_pages_path
    end
    
    def update
      flash[ :notice ] = "Page: #{ page.title } was successfully updated." if page.update_attributes( params[ :page ] )
      respond_with :manage, page, location: manage_pages_path
    end
    
    def destroy
      flash[ :notice ] = "Page: #{ page.title } was successfully deleted." if page.destroy
      respond_with :manage, page, location: manage_pages_path
    end
    
    # ------------------------------------------------------------------
    # Non-RESTful Actions
    
    # POST /manage/page/preview
    def preview
      textile_content   = params[ :textile_content ]                          # Receive the Textile-formatted content via JSON.
      converted_content = ArtisanEngine::Textiling.textile( textile_content ) # Convert the content to Textile.
      render json: { content: converted_content }                             # Render a JSON object with the converted content.
    end
  end
end