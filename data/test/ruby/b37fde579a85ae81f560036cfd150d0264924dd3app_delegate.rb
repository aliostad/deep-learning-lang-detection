class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigationController = UINavigationController.alloc.init
    @navigationController.pushViewController(HomeController.controller,animated:false)

    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    if App::Persistence['authToken'].nil?
      showWelcomeController
    end

    return true
  end

  def showWelcomeController
    @welcomeController = WelcomeController.alloc.init
    @welcomeNavigationController = UINavigationController.alloc.init
    @welcomeNavigationController.pushViewController(@welcomeController, animated:false)

    HomeController.controller.presentModalViewController(@welcomeNavigationController, animated:true)
  end
end
