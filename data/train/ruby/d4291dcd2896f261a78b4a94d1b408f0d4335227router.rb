require 'active_record'
require 'controller'

class Router
  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    controller_name, action_name = router(request.path_info)

    controller_class = load_controller_class(controller_name)
    # controller_class = HomeController
    controller = controller_class.new(action_name)

    # pass req / res to controller
    controller.request = request
    controller.response = response

    controller.public_send(action_name)

    unless controller.rendered
      controller.public_send(:render, action_name)
    end

    response.finish
  end

  def router(url)
    # url = '/home/index'
    # url = '/home'
    # url = '/'
    _, controller_name, action_name = url.split('/')
    [controller_name || 'home', action_name || 'index']
  end

  def load_controller_class(name)
    require "controllers/#{name}_controller.rb"
    Object.const_get(name.capitalize + 'Controller')
  end
end
