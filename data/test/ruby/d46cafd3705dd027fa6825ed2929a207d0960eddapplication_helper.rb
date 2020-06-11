module ApplicationHelper
  def body_classes(controller)
    classes = ""
    if controller.response.status.to_i === 403
      classes += " application status-403"
    elsif controller.response.status.to_i === 404
      classes += " application status-404"
    else
      classes += " #{controller.controller_name} #{controller.action_name} #{controller.controller_name}-#{controller.action_name} #{controller.class.name.split("::").first.downcase}-#{controller.controller_name}-#{controller.action_name}"
    end
    classes
  end
end
