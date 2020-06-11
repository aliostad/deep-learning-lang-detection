module Manage
  class DisplayCasesController < Manage::ManageController
    respond_to :html
    
    expose( :display_cases ) { current_frame.display_cases }
    expose( :display_case )
    expose( :new_collect )   { Collect.new }

    def create
      flash[ :notice ] = "Display Case: #{ display_case.name } was successfully created." if display_case.save
      respond_with :manage, display_case, location: manage_display_cases_path
    end
    
    def update
      flash[ :notice ] = "Display Case: #{ display_case.name } was successfully updated." if display_case.update_attributes( params[ :display_case ] )
      respond_with :manage, display_case, location: manage_display_cases_path
    end
    
    def destroy
      flash[ :notice ] = "Display Case: #{ display_case.name } was successfully destroyed." if display_case.destroy      
      respond_with :manage, display_case
    end
  end
end