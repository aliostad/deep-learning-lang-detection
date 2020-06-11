authorization do
  role :admin do
    # ROLES
    has_permission_on [:admin_categories], :to => [:manage]
    has_permission_on [:admin_pages],      :to => [:manage]
    has_permission_on [:admin_posts],      :to => [:manage]
    has_permission_on [:admin_users],      :to => [:manage]
  end

  role :guest do
    has_permission_on [:pages],            :to => [:read]
  end
end

privileges do
  privilege :manage, :includes => [:read, :create, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => [:create, :new]
  privilege :update, :includes => [:update, :edit]
  privilege :delete, :includes => [:destroy]
end
