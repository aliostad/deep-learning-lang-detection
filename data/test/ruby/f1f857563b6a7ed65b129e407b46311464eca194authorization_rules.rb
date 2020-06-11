authorization do

  role :guest do
    has_permission_on :qfds, :to => [:view, :index,] do
      if_attribute :public => is {true}
    end

    has_permission_on :hoq_lists, :to => [:view, :index] do
      if_permitted_to :view, :qfd
    end

    has_permission_on :hoqs, :to => [:view, :index] do
      if_permitted_to :view, :hoq_list
    end
  end

  role :user do
    includes :guest

    has_permission_on :qfds, :to => :manage do
      if_attribute :user => is {user}
    end

    has_permission_on :qfds, :to => :collaborate do
      if_attribute :rw_invitations => intersects_with {user.invitations_received}
    end

    has_permission_on :hoq_lists, :to => :manage do
      if_permitted_to :manage, :qfd
      if_permitted_to :collaborate, :qfd
    end

    has_permission_on :hoqs, :to => :manage do
      if_permitted_to :manage, :hoq_list
    end

    has_permission_on :requirements_lists, :to => :manage do
      if_permitted_to :manage, :primary_hoq
      if_permitted_to :manage, :secondary_hoq
    end

    has_permission_on :requirements, :to => :manage do
      if_permitted_to :manage, :requirements_list
    end

    has_permission_on :ratings, :to => :manage do
      if_permitted_to :manage, :primary_requirement
      if_permitted_to :manage, :secondary_hoq
    end

    has_permission_on :qfds, :to => :view do
      if_attribute :ro_invitations => intersects_with {user.invitations_received}
    end

  end

end
    
privileges do

  privilege :view do
    includes :read, :show
  end

  privilege :collaborate do
    includes :view, :update
  end

  privilege :manage do
    includes :collaborate, :create, :delete, :destroy, :edit, :index, :new
  end

end
