
class Router
  def route(request)

    if request.get?
      if request.path == '/about'
        controller = AboutController.new(request)
        controller.show
      elsif request.path == '/'
        controller = HomeController.new(request)
        controller.show
      elsif request.path =~ /^\/bios\/.+/
        controller = BiosController.new(request)
        controller.show
      elsif request.path =~ /\/messages\/{0,1}/
        controller = MessagesController.new(request)
        controller.show
      else
        controller = DefaultController.new(request)
        controller.show
      end

    elsif request.post?
      controller = PostController.new(request)
      controller.show
    end

  end
end #Router
