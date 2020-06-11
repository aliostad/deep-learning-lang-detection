class MainViewController < ContainerViewController
  def viewDidLoad
    super

    @authController = AuthController.alloc.init
    @authController.delegate = self

    @myCollectionController = MyCollectionController.alloc.init
    @myCollectionController.delegate = self
    @navigationController = UINavigationController.alloc.initWithRootViewController(@myCollectionController)
  end

  def viewDidAppear(animated)
    if PFUser.currentUser
      showMyCollection
    else
      addContentController(@authController)
    end
  end

  def showMyCollection
    addContentController(@navigationController)
  end

  def myCollectionController(myCollectionController, didLogOutUser: user)
    removeContentController(@myCollectionController)
    addContentController(@authController)
  end

  def authController(authController, didLogInUser: user)
    removeContentController(@authController)
  end
end
