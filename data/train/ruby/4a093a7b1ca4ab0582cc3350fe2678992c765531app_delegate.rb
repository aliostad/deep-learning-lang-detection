include SugarCube::Adjust


class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    AFMotion::Client.build_shared("http://localhost:3000") do
      header "Accept", "application/json"
      operation :json
    end

    url_cache = NSURLCache.alloc.initWithMemoryCapacity(4 * 1024 * 1024, diskCapacity:20 * 1024 * 1024, diskPath:nil)
    NSURLCache.setSharedURLCache(url_cache)

    AFNetworkActivityIndicatorManager.sharedManager.enabled = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    nav_controller =
      UINavigationController.alloc.initWithRootViewController(ClientiTableViewController.controller)
    tab_controller =
      UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [nav_controller]
    @window.rootViewController = tab_controller

    appunti_controller = AppuntiTableViewController.alloc.initWithNibName(nil, bundle: nil)
    appunti_controller.title = "Appunti"
    appunti_nav_controller =
      UINavigationController.alloc.initWithRootViewController(appunti_controller)
 
    user_controller = UserController.alloc.init
    user_controller.title = "Opzioni"
    user_nav_controller =
      UINavigationController.alloc.initWithRootViewController(user_controller)   
    
    image_controller = ImageController.alloc.init
    image_controller.title = "Foto"
    image_nav_controller =
      UINavigationController.alloc.initWithRootViewController(image_controller)   

    tab_controller.viewControllers = [nav_controller, appunti_nav_controller, user_nav_controller, image_nav_controller]



    @login = LoginController.alloc.init
    @login.parent_controller = ClientiTableViewController.controller
    @login_navigation = UINavigationController.alloc.initWithRootViewController(@login)
    ClientiTableViewController.controller.presentModalViewController(@login_navigation, animated:false)

    true


  end
end
