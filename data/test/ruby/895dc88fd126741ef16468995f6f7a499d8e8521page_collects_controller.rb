module Manage
  class PageCollectsController < Manage::ManageController
    respond_to :html, :json
    
    expose( :page_collection )   { current_frame.page_collections.find( params[ :page_collection_id ] ) }
    expose( :page_collects )     { page_collection.page_collects }
    expose( :page_collect )
    
    def create
      flash[ :notice ] = 'Page was successfully added.' if page_collect.save
      respond_with :manage, page_collect, location: edit_manage_page_collection_path( page_collection )
    end
    
    def update
      page_collect.update_attributes( params[ :page_collect ] )
      respond_with :manage, page_collect, location: edit_manage_page_collection_path( page_collection )
    end
    
    def destroy
      flash[ :notice ] = 'Page was successfully removed.' if page_collect.destroy
      respond_with :manage, page_collect, location: edit_manage_page_collection_path( page_collection )
    end
  end
end