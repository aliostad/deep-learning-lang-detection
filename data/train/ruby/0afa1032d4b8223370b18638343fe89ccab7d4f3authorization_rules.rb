authorization do
  role :guest do
    # add permissions for guests here, e.g.
    # has_permission_on :products, :to => :read
  end
  role :admin do
    has_permission_on :products,    :to => :manage
    has_permission_on :deliveries,  :to => :manage
    has_permission_on :services,    :to => :manage
    has_permission_on :categories,  :to => :manage
    has_permission_on :orders,      :to => :manage
    has_permission_on :orders,      :to => :archive
    has_permission_on :todays,      :to => :manage
    has_permission_on :stocks,      :to => :manage
  end
  
  role :prod_admin do
    has_permission_on :products,    :to => :manage
    has_permission_on :categories,  :to => :manage
    has_permission_on :todays,      :to => :manage
  end
  
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
