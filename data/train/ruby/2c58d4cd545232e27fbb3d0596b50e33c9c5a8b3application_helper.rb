module ApplicationHelper
  def is_active_controller(controller_name)
      params[:controller] == controller_name ? (controller_name == "frontend" ? "act":"active") : nil
  end

  def is_active_action(action_name)
      params[:action] == action_name ? (controller_name == "frontend" ? "act":"active") : nil
  end

  def is_active_controller_action(controller_name, action_name)
		params[:controller] == controller_name && params[:action] == action_name ? (controller_name == "frontend" ? "act":"active") : nil
  end
end
