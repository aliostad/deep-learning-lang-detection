module ApplicationHelper
  def javascript_initializer
    controller = full_controller_name.gsub(' ', '.')
    
    root = "window.firstruby"
    
    init_root = "if (#{root}.init != undefined) #{root}.init();\n"
    init_controller = "if(#{root}.#{controller} != undefined && #{root}.#{controller}) { \n"
    init_controller += "\tif(#{root}.#{controller}.init) { #{root}.#{controller}.init(); }\n"
    init_controller += "\tif(#{root}.#{controller}.init_#{action_name}) { #{root}.#{controller}.init_#{action_name}(); }\n"
    init_controller += "}"

    (init_root + init_controller).html_safe

  end
end
