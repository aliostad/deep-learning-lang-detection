class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    controller = ColorsController.alloc.initWithNibName(nil, bundle: nil)
    nav_controller = UINavigationController.alloc.initWithRootViewController(controller)

    top_controller = ColorDetailController.alloc.initWithColor(UIColor.purpleColor)
    top_controller.title = "Top Color"
    top_nav_controller = UINavigationController.alloc.initWithRootViewController(top_controller)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [nav_controller, top_nav_controller]

    @window.rootViewController = tab_controller

    true
  end
end