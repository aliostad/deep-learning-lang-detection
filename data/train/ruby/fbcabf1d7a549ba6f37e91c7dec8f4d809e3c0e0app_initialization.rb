class AppInitialization

  class << self

    def run(window, withUser:user)
      masterController = MasterController.alloc.init
      masterController.user = user
      newsfeedController = NewsfeedController.alloc.init
      newsfeedController.user = CurrentUserManager.sharedInstance
      mainNavController = UINavigationController.alloc.initWithRootViewController(newsfeedController)

      deckController = IIViewDeckController.alloc.initWithCenterViewController(mainNavController, leftViewController:masterController)
      deckController.sizeMode = IIViewDeckViewSizeMode
      deckController.leftSize = -20

      window.setRootViewController(deckController)
    end

  end

end