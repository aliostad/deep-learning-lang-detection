class AuthorizeFilter
  def self.authorize_admin(controller)
    if not controller.current_user or not controller.current_user.is_admin?
        controller.flash[:notice] = "Sorry, authorization denied"
        controller.redirect_to controller.root_url
    end
  end
  
  def self.authorize_writer(controller)
    if not controller.current_user or not controller.current_user.is_writer? or not controller.current_user.is_admin?
        controller.flash[:notice] = "Sorry, authorization denied"
        controller.redirect_to controller.root_url
    end
  end
  
  def self.authorize_own(user_id, controller)
    puts "Boolean #{controller.current_user.id != user_id}"
    if controller.current_user.id != user_id
      puts "inside BLOCK"
        controller.flash[:notice] = "Sorry, authorization denied"
        controller.redirect_to controller.root_url
    end
  end
end