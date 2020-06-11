class ManageUserAccesses < ActiveRecord::Migration
  def self.up
    add_column :user_accesses, :manage_customers, :boolean, :default => false
    add_column :user_accesses, :manage_tickets, :boolean, :default => false
    add_column :user_accesses, :manage_ticket_categories, :boolean, :default => false
    add_column :user_accesses, :manage_agents, :boolean, :default => false

    UserAccess.update_all("manage_customers = can_edit_customer")
    UserAccess.update_all("manage_tickets = can_create_ticket")

    remove_column :user_accesses, :can_edit_customer
    remove_column :user_accesses, :can_create_ticket

    admin = User.find_by_login('admin')
    if admin
      ua = admin.user_access
      ua.manage_agents = ua.manage_customers = ua.manage_tickets = ua.manage_ticket_categories = true
      ua.save!
    end
  end

  def self.down
    add_column :user_accesses, :can_edit_customer, :boolean
    add_column :user_accesses, :can_create_ticket, :boolean

    UserAccess.update_all("can_edit_customer = manage_customers")
    UserAccess.update_all("can_create_ticket = manage_tickets")

    remove_column :user_accesses, :manage_customers, :boolean
    remove_column :user_accesses, :manage_tickets, :boolean
    remove_column :user_accesses, :manage_ticket_categories, :boolean
    remove_column :user_accesses, :manage_agents, :boolean
  end
end
