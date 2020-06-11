# Router
class Router
  def route(request)
    if request.post?
      controller = MessagesController.new(request)
      controller.postmessage
    elsif request.get?
      if request.path == '/messages'
        controller = MessagesController.new(request)
        controller.show
      elsif request.path == '/about'
        controller = AboutController.new(request)
        controller.show
      elsif request.path =~ /\/bios\/.+/
        controller = BiosController.new(request)
        controller.show
      else request.path == '/'
        controller = HomeController.new(request)
        controller.show
      end
    else
      "It was something else!"
    end
  end
end
