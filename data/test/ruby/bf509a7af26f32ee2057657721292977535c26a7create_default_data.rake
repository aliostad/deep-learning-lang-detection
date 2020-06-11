task :create_default_data => :environment do
  if Permission.count == 0
    permissions = [{
      :name => "Full Access on Organization Management",
      :code => "full_organization_management",
      :group_permission_name => "Manage Organizations"
    },{
      :name => "Full Access on Functional User Group",
      :code => "full_group_management",
      :group_permission_name => "Manage User Groups"
    },{
      :name => "Full Access on User Management",
      :code => "full_user_management",
      :group_permission_name => "Manage Users"
    },{
      :name => "View Log",
      :code => "view_log",
      :group_permission_name => "Manage Logs"
    },{
      :name => "View List of Organization(s)",
      :code => "view_organization",
      :group_permission_name => "Manage Organizations"
    },{
      :name => "View  User Group",
      :code => "view_group",
      :group_permission_name => "Manage User Groups"
    },{
      :name => "View User",
      :code => "view_user",
      :group_permission_name => "Manage Users"
    }]

    permissions = Permission.create(permissions)
  end
end