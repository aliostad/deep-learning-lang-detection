class AppDelegate
  extend IB

  outlet :window, UIWindow

  outlet :settingsAnimationController, CEReversibleAnimationController
  outlet :navigationControllerAnimationController, CEReversibleAnimationController
  outlet :navigationControllerInteractionController, CEBaseInteractionController
  outlet :settingsInteractionController, CEBaseInteractionController

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # self.settingsInteractionController = CEReversibleAnimationController.alloc.init
    # self.navigationControllerInteractionController = CEReversibleAnimationController.alloc.init
    # self.navigationControllerInteractionController = CEBaseInteractionController.alloc.init
    # self.settingsInteractionController = CEBaseInteractionController.alloc.init
    true
  end
end
