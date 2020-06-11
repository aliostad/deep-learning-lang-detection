class RolesActions < ActiveRecord::Migration
  def change
  	#creates controller
  	ControllerAction.create(:name => "roles")
  	controller = ControllerAction.where(name: 'roles', controller_action_id: nil).first
  	ControllerAction.create(:name => "index", :controller_action_id => controller.id)
  	ControllerAction.create(:name => "show", :controller_action_id => controller.id)
  	ControllerAction.create(:name => "create", :controller_action_id => controller.id)
  	ControllerAction.create(:name => "destroy", :controller_action_id => controller.id)
  	ControllerAction.create(:name => "update", :controller_action_id => controller.id)
  	admin = Role.find(1)
  	admin.controller_actions << controller

  end
end
