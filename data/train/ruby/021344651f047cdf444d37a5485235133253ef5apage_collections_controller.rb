module Manage
  class PageCollectionsController < Manage::ManageController
    respond_to :html
    
    expose( :page_collections ) { current_frame.page_collections }
    expose( :page_collection )
    expose( :new_page_collect ) { PageCollect.new }

    def create
      flash[ :notice ] = "Page Collection: #{ page_collection.name } was successfully created." if page_collection.save
      respond_with :manage, page_collection, location: manage_page_collections_path
    end
    
    def update
      flash[ :notice ] = "Page Collection: #{ page_collection.name } was successfully updated." if page_collection.update_attributes( params[ :page_collection ] )
      respond_with :manage, page_collection, location: manage_page_collections_path
    end
    
    def destroy
      flash[ :notice ] = "Page Collection: #{ page_collection.name } was successfully destroyed." if page_collection.destroy      
      respond_with :manage, page_collection
    end
  end
end