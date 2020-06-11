module PCPageViewControllerDataSource
  def pageViewController(pageViewController, viewControllerBeforeViewController: viewController)
    if viewController.index > 0
      self.viewControllerAtIndex(viewController.index - 1)
    else
      nil
    end
  end

  def pageViewController(pageViewController, viewControllerAfterViewController: viewController)
    if viewController.index < (Stop.count - 1)
      self.viewControllerAtIndex(viewController.index + 1)
    else
      nil
    end
  end

  def presentationCountForPageViewController(pageViewController)
    Stop.count
  end

  def presentationIndexForPageViewController(pageViewController)
    0
  end
end
