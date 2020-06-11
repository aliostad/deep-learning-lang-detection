module ApplicationHelper

  def controller_assets
    controller = params[:controller]
    if Rails.application.config.controllers_with_assets.include? controller
      javascript_include_tag(controller) + stylesheet_link_tag(controller)
    end
  end

  def views_assets
    action = params[:action]
    controller = params[:controller]
    controller_action = controller + '_' + action
    if Rails.application.config.controller_views_with_assets.include? controller_action
      javascript_include_tag(controller_action) + stylesheet_link_tag(controller_action)
    end
  end
end
