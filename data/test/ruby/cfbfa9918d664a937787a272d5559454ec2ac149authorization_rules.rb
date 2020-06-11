authorization do
  role :guest do
    # add permissions for guests here, e.g.
    # has_permission_on :conferences, :to => :read
  end
  role :school do
    has_permission_on :profiles, :to => [:collaborate]
  end
  role :admin do
    has_permission_on :corkboards, :to => [:manage]
    has_permission_on [:corkboards, :corkcontents], :to => [:manage]
    has_permission_on :corkcontents, :to => [:manage]
    has_permission_on :activities, :to => [:read]
    has_permission_on [:splats, :comments], :to => [:manage]
    has_permission_on [:corkcontents, :concomments], :to => [:manage]
  end
  role :teacher do    
    has_permission_on :activities, :to => [:manage]
    has_permission_on :corkboards, :to => [:manage]
    has_permission_on :corkcontents, :to => [:manage]
    has_permission_on [:corkboards, :corkcontents], :to => [:manage]
    has_permission_on [:splats, :comments], :to => [:manage]
    has_permission_on [:corkcontents, :concomments], :to => [:manage]    
  end
  role :student do
    has_permission_on :activities, :to => [:manage]
    has_permission_on :corkboards, :to => [:manage]
    has_permission_on :corkcontents, :to => [:manage]
    has_permission_on [:corkboards, :corkcontents], :to => [:manage]
    has_permission_on [:splats, :comments], :to => [:manage]
    has_permission_on [:corkcontents, :concomments], :to => [:manage]    
  end
  # permissions on other roles, such as
  # role :admin do
  #   has_permission_on :conferences, :to => :manage
  # end
  # role :user do
  #   has_permission_on :conferences, :to => [:read, :create]
  #   has_permission_on :conferences, :to => [:update, :delete] do
  #     if_attribute :user_id => is {user.id}
  #   end
  # end
  # See the readme or GitHub for more examples
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show, :vote]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
