class AdjustAdminPermitions < ActiveRecord::Migration
  def change
  	 admin = Role.find(1)
  	 admin.controller_actions.delete(ControllerAction.find(1))
  	 admin.controller_actions.delete(ControllerAction.find(8))
  	 admin.controller_actions.delete(ControllerAction.find(16))
  	 admin.controller_actions << ControllerAction.find(2)
  	 admin.controller_actions << ControllerAction.find(3)
  	 admin.controller_actions << ControllerAction.find(4)
  	 admin.controller_actions << ControllerAction.find(5)
  	 admin.controller_actions << ControllerAction.find(6)
  	 admin.controller_actions << ControllerAction.find(7)
  	 admin.controller_actions << ControllerAction.find(9)
  	 admin.controller_actions << ControllerAction.find(10)
  	 admin.controller_actions << ControllerAction.find(11)
  	 admin.controller_actions << ControllerAction.find(12)
  	 admin.controller_actions << ControllerAction.find(13)
  	 admin.controller_actions << ControllerAction.find(14)
  	 admin.controller_actions << ControllerAction.find(15)
  	 admin.controller_actions << ControllerAction.find(17)
  end
end
