class ApplicationController < ActionController::Base
  protect_from_forgery
  @@resource_offer_handler = nil


  def self.resource_offer_handler 
    if !@@resource_offer_handler && !ENV["PENDING_MIGRATIONS"]
      @@resource_offer_handler = ResourceOfferHandler.make_singleton
    end
    @@resource_offer_handler
  end

  def self.update_resource_info(spots)
    if resource_offer_handler
      resource_offer_handler.update_resource_info(spots)
    end
  end

  def self.update_resource_availability(spots)
    if resource_offer_handler
      resource_offer_handler.update_resource_availability(spots)
    end
  end

end
