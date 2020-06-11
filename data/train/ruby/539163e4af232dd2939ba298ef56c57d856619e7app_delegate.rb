class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigation_controller = UINavigationController.alloc.init
    @navigation_controller.pushViewController(TasksListController.controller, animated: false)

    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    if App::Persistence['authToken'].nil?
      show_welcome_controller
    end

    true
  end

  def show_welcome_controller
    @welcome_controller = WelcomeController.alloc.init
    @welcome_navigation_controller = UINavigationController.alloc.init

    @welcome_navigation_controller.pushViewController(@welcome_controller, animated: false)

    TasksListController.controller.presentModalViewController(@welcome_navigation_controller, animated: true)
  end
end
