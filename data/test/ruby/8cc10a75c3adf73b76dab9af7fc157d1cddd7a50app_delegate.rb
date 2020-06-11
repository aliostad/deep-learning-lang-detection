class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    feedViewController = FeedViewController.alloc.init
    favoritesViewController = FavoritesViewController.alloc.init
    profileViewController = ProfileViewController.alloc.init

    feedNavController = UINavigationController.alloc.initWithRootViewController feedViewController
    favoritesNavController = UINavigationController.alloc.initWithRootViewController favoritesViewController
    profileNavController = UINavigationController.alloc.initWithRootViewController profileViewController

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    tabBarController = UITabBarController.alloc.init
    tabBarController.setViewControllers([feedNavController,
                                         favoritesNavController,
                                         profileNavController])

    @window.rootViewController = tabBarController

    true
  end
end
