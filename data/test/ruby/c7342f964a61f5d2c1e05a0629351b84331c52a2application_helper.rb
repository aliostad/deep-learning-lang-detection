module ApplicationHelper
  def appropriate
    (controller.controller_name == "posts" && controller.action_name == "index") || 
    (controller.controller_name == "users" && controller.action_name == "show") || 
    (controller.controller_name == "cities" && controller.action_name == "show") || 
    (controller.controller_name == "posts" && controller.action_name == "most_liked") ||
    (controller.controller_name == "posts" && controller.action_name == "most_disliked")  
  end
  
  def hide_user_mod
    (controller.controller_name =~ /sessions/)
  end
end
