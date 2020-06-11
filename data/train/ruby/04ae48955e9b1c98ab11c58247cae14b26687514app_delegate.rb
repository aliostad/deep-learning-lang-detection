class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController splash_controller

    true
  end

  def splash_controller
    @splash_controller ||= SplashController.new
  end

  def lost_controller
    @lost_controller ||= LostController.new
  end

  def found_controller
    @found_controller ||= FoundController.new
  end

  def orphan_controller
    @orphan_controller ||= OrphanController.new
  end

  def handle_error error
    App.alert error.message
    @window.rootViewController.popToViewController splash_controller, animated: false
  end
end
