class ContainerViewController < UIViewController
  def addContentController(contentController)
    addChildViewController(contentController)
    contentController.view.frame = view.frame
    view.addSubview(contentController.view)
    contentController.didMoveToParentViewController(self)
  end

  def removeContentController(contentController)
    contentController.willMoveToParentViewController(nil)
    contentController.view.removeFromSuperview
    contentController.removeFromParentViewController
  end
end
