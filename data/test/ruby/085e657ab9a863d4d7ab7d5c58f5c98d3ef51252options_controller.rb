module Manage
  class OptionsController < Manage::ManageController
    respond_to :html
    
    expose( :goods )   { current_frame.goods }
    expose( :good )
    expose( :options ) { good.options }
    expose( :option )
    
    def create
      flash[ :notice ] = "Option was successfully added." if option.save
      respond_with :manage, option, location: edit_manage_good_path( good )
    end
    
    def update
      flash[ :notice ] = "Option was successfully updated." if option.update_attributes( params[ :option ] )
      respond_with :manage, option, location: edit_manage_good_path( good )
    end
    
    def destroy
      flash[ :notice ] = "Option was successfully removed." if option.destroy
      respond_with :manage, option, location: edit_manage_good_path( good )
    end
  end
end