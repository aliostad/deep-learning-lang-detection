class AddSearchToUserAndRoles < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
  	ControllerAction.create(:name => "search", :controller_action_id => controller.id)

  	admin = Role.find(1)
  	admin.controller_actions << controller.controller_actions.where(name: 'search').first

  	controller = ControllerAction.where(name: 'roles', controller_action_id: nil).first
  	ControllerAction.create(:name => "search", :controller_action_id => controller.id)

  	admin.controller_actions << controller.controller_actions.where(name: 'search').first

  end
end
