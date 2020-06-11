class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
		window.makeKeyAndVisible
		window.rootViewController = rootViewController
    true
  end

	def rootViewController
		tabBarController
	end

	def tabBarController
		@tabBarController ||= UITabBarController.alloc.initWithNibName(nil, bundle: nil).tap do |controller|
			controller.viewControllers = [colorsNavigationController, topColorNavigationController]
		end
	end

	def topColorNavigationController
		UINavigationController.alloc.initWithRootViewController topColorController
	end

	def colorsNavigationController
		UINavigationController.alloc.initWithRootViewController colorsController
	end

	def topColorController
		ColorDetailController.alloc.initWithColor(UIColor.purpleColor).tap do |controller|
			controller.title = "Top Color"
			controller.edgesForExtendedLayout = UIRectEdgeNone
		end
	end

	def colorsController
		ColorsController.alloc.initWithNibName(nil, bundle: nil)
	end

	def window
		@window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
	end
end
