class CompaniesControllerActions < ActiveRecord::Migration
  def change
  	#creates controller
  	ControllerAction.create(:name => "companies")
  	controller = ControllerAction.where(name: 'companies', controller_action_id: nil).first
  	
  	#creates actions
  	ControllerAction.create(:name => "index", :controller_action_id => controller.id)
    ControllerAction.create(:name => "show", :controller_action_id => controller.id)
    ControllerAction.create(:name => "create", :controller_action_id => controller.id)
    ControllerAction.create(:name => "destroy", :controller_action_id => controller.id)
    ControllerAction.create(:name => "update", :controller_action_id => controller.id)
    ControllerAction.create(:name => "search", :controller_action_id => controller.id)
    ControllerAction.create(:name => "get_vehicles", :controller_action_id => controller.id)

  	actions = []
  	actions << controller.controller_actions.where(name: 'index').first
    actions << controller.controller_actions.where(name: 'show').first
    actions << controller.controller_actions.where(name: 'create').first
    actions << controller.controller_actions.where(name: 'destroy').first
    actions << controller.controller_actions.where(name: 'update').first
    actions << controller.controller_actions.where(name: 'search').first
    actions << controller.controller_actions.where(name: 'get_vehicles').first

  	#asigns actions to role
  	admin = Role.find(1)
  	admin.controller_actions << actions

  	#creates two companies to test
  	Company.create(:name => "Company1", :phone => "5608937", :representative => "Laura Herrera", :nit => "123456789", :address => "CALLE 5A # 29 12", :email => "lauraherra@gmail.com")
  	Company.create(:name => "Company2", :phone => "2776584", :representative => "Jose Rodriguez", :nit => "987654321", :address => "CALLE 100 # 14 83", :email => "joserodriguez@gmail.com")
  end
end