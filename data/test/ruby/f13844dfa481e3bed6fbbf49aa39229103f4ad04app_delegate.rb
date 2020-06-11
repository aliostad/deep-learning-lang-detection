class AppDelegate
  attr_accessor :tap_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    # ナビゲーションコントローラの中身
    tap_controller = TapController.alloc.initWithNibName nil, bundle:nil

    # ナビゲーションコントローラ
    nav_controller = UINavigationController.alloc.initWithRootViewController tap_controller

    # コンンローラ2 ただのビュー
    b_controller = AlphabetController.alloc.initWithNibName(nil, bundle: nil)

    # ルートビューコントローラ
    tab_controller = UITabBarController.alloc.initWithNibName nil, bundle: nil
    tab_controller.viewControllers = [nav_controller, b_controller]
    self.tap_controller = tap_controller

    @window.rootViewController = tab_controller

    
    true
  end
end
