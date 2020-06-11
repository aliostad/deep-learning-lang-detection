module ApplicationHelper
  def title(page_title)
    content_for(:title) { h(page_title.to_s) }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  def selected_class (but)
    case but
      when 'home'
        return "selected" if controller.controller_name == "home" and controller.action_name == "index"
      when 'course'
        return "selected" if controller.controller_name == "home" and controller.action_name == "course"
      when 'project'
        return "selected" if controller.controller_name == "home" and controller.action_name == "format" or controller.action_name == "project"
      when 'sessions'
        return "selected" if controller.controller_name =="sessions" and controller.action_name == "index" or controller.action_name == "login" or (controller.controller_name == "annees" and controller.action_name =="index" or controller.action_name =="new" or controller.action_name =="edit" or controller.action_name =="show")  or (controller.controller_name == "projects" and controller.action_name =="index" or controller.action_name =="new" or controller.action_name =="edit" or controller.action_name =="show") or (controller.controller_name == "students" and controller.action_name =="index" or controller.action_name =="new" or controller.action_name =="edit" or controller.action_name =="show" or controller.action_name =="projects") or (controller.controller_name == "teachers" and controller.action_name =="index" or controller.action_name =="new" or controller.action_name =="edit" or controller.action_name =="show"  or controller.action_name =="projects")
      else return "selected" if controller.controller_name == but
    end
  end
end