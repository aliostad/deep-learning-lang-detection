class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.rootViewController =  navController
    window.backgroundColor = UIColor.whiteColor
    window.makeKeyAndVisible

    true
  end

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  ###########
  # Nav/Tab #
  ###########

  def navController
    @navController ||= begin
      _navController = UINavigationController.alloc.initWithRootViewController (mainController)
      _navController.wantsFullScreenLayout = true;
      _navController.setNavigationBarHidden(true, animated: false)
      _navController
    end
  end

   def tabBarController
     @tabBarController ||= begin
      _tabBarController = UITabBarController.alloc.init
      _tabBarController.viewControllers = [mainController] #[splashController, mainController, alarmController]
      _tabBarController.selectedIndex = 0
      _tabBarController
    end
  end

  #########
  # Pages #
  #########

  def mainController
    @mainController ||= MainController.new
  end

  def alarmController
    @alarmController ||= AlarmController.new
  end

  def splashController
    @splashController ||= SplashController.new
  end
end
