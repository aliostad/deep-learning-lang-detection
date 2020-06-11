class Router
  def route(request)
    if request.get?
      if request.path == '/about'
        controller = AboutController.new(request)
        controller.show
      elsif request.path =~ /\/bios\/.+/
        controller = BiosController.new(request)
        controller.show
      elsif request.path == '/messages'
        controller = MessagesController.new(request)
        controller.show
      else
        controller = HomeController.new(request)
        controller.show
      end
    elsif request.post?
      controller = MessagesController.new(request)
      controller.create
    else
      "Invalid request method #{request.env['REQUEST_METHOD']}"      
    end
  end
end
