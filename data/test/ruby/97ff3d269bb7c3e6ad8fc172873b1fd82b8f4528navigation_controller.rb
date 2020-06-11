class NavigationController < UINavigationController
  def initWithCoder(aDecoder)
    super
    self.delegate = self
    self
  end

  def navigationController(navigationController, animationControllerForOperation: operation, fromViewController: fromVC, toViewController: toVC)
    if application_delegate.navigationControllerInteractionController
      application_delegate.navigationControllerInteractionController.wireToViewController(toVC, forOperation: CEInteractionOperationPop)
    end
    if application_delegate.navigationControllerAnimationController
      application_delegate.navigationControllerAnimationController.reverse = (operation == UINavigationControllerOperationPop)
    end
    application_delegate.navigationControllerAnimationController
  end

  def navigationController(navigationController, interactionControllerForAnimationController: animationController)
    # if we have an interaction controller - and it is currently in progress, return it
    application_delegate.navigationControllerInteractionController &&
      application_delegate.navigationControllerInteractionController.interactionInProgress ? application_delegate.navigationControllerInteractionController : nil
  end

  def application_delegate
     UIApplication.sharedApplication.delegate
  end
end
