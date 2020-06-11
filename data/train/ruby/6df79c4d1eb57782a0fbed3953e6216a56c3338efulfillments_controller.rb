module Manage
  class FulfillmentsController < Manage::ManageController
    respond_to :html
    
    expose( :orders )            { current_frame.orders }
    expose( :order )             { orders.find_by_id_in_frame( params[ :order_id ] ) }
    expose( :fulfillment )
    expose( :unfulfilled_items ) { order.line_items.unfulfilled }
  
    def create
      fulfillment.order = order
      
      if fulfillment.save
        flash[ :notice ] = "Fulfillment was successfully created." 
        OrderMailer.patron_fulfillment_confirmation_email( fulfillment, current_frame ).deliver if params[ :send_confirmation_email ] 
      end
      
      respond_with :manage, order, fulfillment, location: manage_order_path( order )
    end
  end
end