class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @timeline = UINavigationController.alloc.init
    @timeline.pushViewController(TimelineController.controller, animated:false)

    @mentions = UINavigationController.alloc.init
    @mentions.pushViewController(MentionsController.controller, animated:false)

    @tabBarController = UITabBarController.alloc.init
    @tabBarController.viewControllers = [@timeline, @mentions]

    @window.rootViewController = @tabBarController
    @window.makeKeyAndVisible

    showAccountSelectorController unless account

    true
  end

  def showAccountSelectorController
    @accountSelectorController = AccountSelectorController.alloc.init
    @accountSelectorNavigationController = UINavigationController.alloc.init
    @accountSelectorNavigationController.pushViewController(@accountSelectorController, animated:false)

    TimelineController.controller.presentModalViewController(@accountSelectorNavigationController, animated:false)
  end

  def account
    @account ||= Account.find(App::Persistence['account_id'])
  end

  def reset_account
    App::Persistence['account_id'] = nil
  end
end
