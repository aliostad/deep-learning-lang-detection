authorization do
  role :guest do
    #has_permission_on :games, :to => :read
  end
  
  role :member do
    has_permission_on :members_games, :to => :manage
    has_permission_on :members_users, :to => :manage
  end
  
  role :admin do
    has_permission_on :admin_admin, :to => :manage
    has_permission_on :admin_games, :to => :manage
    has_permission_on :admin_users, :to => :manage
    has_permission_on :admin_roles, :to => :manage
    #has_permission_on :games, :to => :manage
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end