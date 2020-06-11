module RevealControllerManager

  def toggle_menu
    showing_left_controller? ? show_front_controller : show_left_controller
    rmq(:navigation_bar).reapply_styles
  end

  def q
    self.is_a?(UIViewController) ? rmq : owner.rmq
  end

  def reveal_controller
    RubyMotionQuery::App.window.rootViewController
  end

  def showing_left_controller?
    reveal_controller.state == 2 || reveal_controller.isPresentationModeActive
  end

  def show_front_controller
    front_view_controller.topViewController.view.alpha = 1.0
    reveal_controller.resignPresentationModeEntirely(
      true,
      animated: true,
      completion: -> (finished) {reveal_controller.showViewController(front_view_controller)}
    )
  end

  def switch_front_controller_to(controller_class)
    front_view_controller.setViewControllers([controller_class.new], animated: false)
    reveal_controller.resignPresentationModeEntirely(true, animated: true, completion: -> (finished) { q.all.reapply_styles})
  end

  def push_onto_front_controller(controller)
    front_view_controller.pushViewController(controller, animated: false)
    reveal_controller.resignPresentationModeEntirely(true, animated: true, completion: -> (finished) { q.all.reapply_styles})
  end

  def switch_front_controller_to_web_request(controller_class)
    left_view_controller.presentViewController(controller_class.new, animated: true, completion: -> { q.all.reapply_styles})
  end

  def show_left_controller
    reveal_controller.showViewController(left_view_controller)
  end

  def left_view_controller
    reveal_controller.leftViewController
  end

  def front_view_controller
    reveal_controller.frontViewController
  end

  def return_menu_to_base_state
    left_view_controller.popToRootViewControllerAnimated(false)
    rmq(:navigation_bar).reapply_styles
  end
end