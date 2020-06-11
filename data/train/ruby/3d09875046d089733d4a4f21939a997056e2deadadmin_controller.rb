class Calendar::AdminController < ModuleController
  permit 'calendar_admin'

  component_info 'Calendar', :description => 'Calendar Component', 
                              :access => :private
                              
  register_permission_category :calendar, "Calendar" ,"Permissions for Calendar Actions"
  
  register_permissions :calendar, [  [ :manage, 'Calendar Manage', 'Manage Calendar and Events' ],
                                 [ :admin, 'Calendadr Admin', 'Manage Calendar Configuration']
                             ]

  content_model :calendar
  
  register_handler :shop, :product_feature, "Calendar::BookingCreditPack"

  register_handler :members, :view,  "Calendar::ManageController"

   module_for :ical, 'Event Ical', :description => 'Add ical links to your site'

  
   def ical
     render :nothing => true
   end

  protected
 def self.get_calendar_info
      [
      {:name => "Appointment",:url => { :controller => '/calendar/manage' } ,:permission => 'calendar_manage', :icon => 'icons/content/calendar.gif' }
      ]
  end

end
