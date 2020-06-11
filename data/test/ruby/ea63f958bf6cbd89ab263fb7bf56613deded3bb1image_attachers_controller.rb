module Manage
  class ImageAttachersController < Manage::ManageController
    respond_to :html, :json
    
    expose( :images )         { current_frame.images }
    expose( :image_attacher )
    expose( :parent )         { current_frame.goods.find( params[ :good_id ] ) }

    def create
      image_attacher.imageable = parent
      flash[ :notice ] = "Image successfully attached." if image_attacher.save 
      respond_with :manage, image_attacher, location: polymorphic_url( [ :manage, parent ], action: :edit )
    end
    
    def update
      image_attacher.imageable = parent
      image_attacher.update_attributes( params[ :image_attacher ] )
      respond_with :manage, image_attacher, location: polymorphic_url( [ :manage, parent ], action: :edit )
    end
    
    def destroy
      flash[ :notice ] = "Image successfully removed." if image_attacher.destroy
      respond_with :manage, image_attacher, location: polymorphic_url( [ :manage, parent ], action: :edit )
    end
  end
end