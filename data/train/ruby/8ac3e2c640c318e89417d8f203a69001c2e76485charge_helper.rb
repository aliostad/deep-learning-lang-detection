module ChargeHelper
  def page_title
    if controller.controller_name == "vendors" && controller.action_name == "index"
      "商铺管理"
    elsif controller.controller_name == "vendors" && controller.action_name == "edit"
      "编辑商铺"
    elsif controller.controller_name == "vendors" && controller.action_name == "show"
      @vendor.name_zh
    elsif controller.controller_name == "promotions" && controller.action_name == "index"
      "促销管理"
    elsif controller.controller_name == "promotions" && controller.action_name == "edit"
      "促销处理"
    elsif controller.controller_name == "promotions" && controller.action_name == "show"
      @promotion.title
    else
      "管理后台"
    end
  end

  def common_actions
    actions = ""
    if controller.controller_name == "vendors" && controller.action_name == "index"
      actions << ""
    elsif controller.controller_name == "vendors" && controller.action_name == "show"
      actions << "#{link_to '编辑商铺', edit_charge_vendor_path(@vendor)}"
    end
  end
  
end
