module Manage
  class CollectsController < Manage::ManageController
    respond_to :html, :json
    
    expose( :display_case ) { current_frame.display_cases.find( params[ :display_case_id ] ) }
    expose( :collects )     { display_case.collects }
    expose( :collect )
    
    def create
      flash[ :notice ] = 'Good was successfully added.' if collect.save
      respond_with :manage, collect, location: edit_manage_display_case_path( display_case )
    end
    
    def update
      collect.update_attributes( params[ :collect ] )
      respond_with :manage, collect, location: edit_manage_display_case_path( display_case )
    end
    
    def destroy
      flash[ :notice ] = 'Good was successfully removed.' if collect.destroy
      respond_with :manage, collect, location: edit_manage_display_case_path( display_case )
    end
  end
end