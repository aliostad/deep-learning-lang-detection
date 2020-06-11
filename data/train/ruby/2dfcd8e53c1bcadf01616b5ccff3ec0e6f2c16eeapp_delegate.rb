class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    garden_controller = GardenController.alloc.initWithNibName(nil, bundle:nil)
    flower_controller = FlowerController.alloc.init

    garden_nav_controller = UINavigationController.alloc.initWithRootViewController(garden_controller)
    flower_nav_controller = UINavigationController.alloc.initWithRootViewController(flower_controller)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle:nil)
    tab_controller.viewControllers = [garden_nav_controller, flower_nav_controller]

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = tab_controller
    @window.makeKeyAndVisible

    true
  end
end
