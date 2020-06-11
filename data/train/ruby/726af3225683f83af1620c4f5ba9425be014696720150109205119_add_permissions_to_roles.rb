class AddPermissionsToRoles < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'roles', controller_action_id: nil).first
  	ControllerAction.create(:name => "show_permissions", :controller_action_id => controller.id)
  	ControllerAction.create(:name => "assign_permissions", :controller_action_id => controller.id)
  	actions = []
  	actions << controller.controller_actions.where(name: 'show_permissions').first
  	actions << controller.controller_actions.where(name: 'assign_permissions').first
  	admin = Role.find(1)
  	for action in actions
  		admin.controller_actions << action
  	end
  end
end