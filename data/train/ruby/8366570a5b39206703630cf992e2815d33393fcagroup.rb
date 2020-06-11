class Group < ActiveRecord::Base
  include BitFlags
  
  has_and_belongs_to_many :users, :join_table => :user_groups
  has_many :issue_status_permissions
  
  validates :name, presence: true
  
  bit_flags :system_flags, {
    0 => :manage_users,
    1 => :manage_products,
    2 => :manage_working_flow
  }
  
  PERMISSIONS = {
    :manage_users => 'admin.manage_users',
    :manage_products => 'admin.manage_products',
    :manage_working_flow => 'admin.manage_working_flow'
  }
  
  def permissions
    roles = Set.new
    PERMISSIONS.each do |symbol, role|
      if self.send(symbol)
        splited_role = role.split('.')
        splited_role.length.times do |i|
          roles.add splited_role[0..i].join('.')
        end
      end
    end
    roles.to_a
  end
end
