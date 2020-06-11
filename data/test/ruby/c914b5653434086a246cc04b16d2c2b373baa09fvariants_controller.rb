module Manage
  class VariantsController < Manage::ManageController
    respond_to :html, :js, :json
    
    expose( :goods )        { current_frame.goods }
    expose( :good )
    expose( :good_options ) { good.options.in_order }
    expose( :variants )     { good.variants }
    expose( :variant )
    
    def create
      flash[ :notice ] = "Variant was successfully created." if variant.save and !request.xhr?
      respond_with :manage, good, variant, location: edit_manage_good_path( good )
    end
    
    def update
      flash[ :notice ] = "Variant was successfully updated." if variant.update_attributes( params[ :variant ] ) and !request.xhr?
      respond_with :manage, good, variant, location: edit_manage_good_path( good )
    end  
    
    def destroy
      flash[ :notice ] = "Variant was successfully destroyed." if variant.destroy and !request.xhr?
      respond_with :manage, good, variant, location: edit_manage_good_path( good )
    end
  end
end