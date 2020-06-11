class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    list_controller = UINavigationController.alloc.
      initWithRootViewController(ListViewController.alloc.init)
    thumbnails_controller = UINavigationController.alloc.
      initWithRootViewController(ThumbnailsViewController.alloc.init)

    list_controller.navigationBar.tintColor = UIColor.grayColor
    thumbnails_controller.navigationBar.tintColor = UIColor.grayColor

    tab_controller = UITabBarController.alloc.init
    tab_controller.viewControllers = [list_controller, thumbnails_controller]

    @window.rootViewController = tab_controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end
end
