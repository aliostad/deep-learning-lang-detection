class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    main_controller = MainController.alloc.initWithNibName(nil, bundle: nil)
    main_navigation_controller = UINavigationController.alloc.initWithRootViewController(main_controller)
    guidance_controller = GuidanceController.alloc.initWithNibName(nil, bundle: nil)
    guidance_navigation_controller = UINavigationController.alloc.initWithRootViewController(guidance_controller)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [main_navigation_controller, guidance_navigation_controller]

    @window.rootViewController = tab_controller

    true
  end
end
