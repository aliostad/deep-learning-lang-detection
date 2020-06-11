module Manage
  class PromotionsController < Manage::ManageController
    respond_to :html
    
    expose( :promotions ) { current_frame.promotions }
    expose( :promotion )
    
    def create
      flash[ :notice ] = "Promotion: #{ promotion.promotional_code } was successfully created." if promotion.save
      respond_with :manage, promotion, location: manage_promotions_path
    end
    
    def update
      flash[ :notice ] = "Promotion: #{ promotion.promotional_code } was successfully updated." if promotion.update_attributes( params[ :promotion ] )
      respond_with :manage, promotion, location: manage_promotions_path
    end
    
    def destroy
      flash[ :notice ] = "Promotion: #{ promotion.promotional_code } was successfully destroyed." if promotion.destroy
      respond_with :manage, promotion
    end
  end
end