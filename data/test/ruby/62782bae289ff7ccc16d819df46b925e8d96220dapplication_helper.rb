module ApplicationHelper
  include TzMagic::ApplicationHelper

  def memberships_link_active?
    controller.controller_name == "memberships" && controller.action_name != 'index'
  end

  def inscriptions_link_active?
    controller.controller_name == "inscriptions"
  end

  def closures_link_active?
    controller.controller_name == "closures"
  end

  def reports_active?
    (controller.controller_name == "memberships" && controller.action_name == 'index') ||
    (controller.controller_name == "installments" && controller.action_name == 'index')
  end
end
