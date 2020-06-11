
authorization do
  role :organisation_owner do
    has_permission_on :school_admin_groups, :to => [:index, :add_group, :delete_group, :delete, :create]
    has_permission_on :channels, :to => [:manage, :welcome]
    has_permission_on :slides, :to => [:manage, :sort, :slide_status, :toggle_status]
    has_permission_on :slide_timers, :to => :manage
    has_permission_on :displays, :to => :manage
  end

  role :school_admin do
    has_permission_on :channels, :to => [:manage, :welcome] do
      if_attribute :school_id => is_in {user.admin_of_schools}
    end
    has_permission_on :slides, :to => [:manage, :sort, :slide_status, :toggle_status] do
      if_attribute :school_id => is_in {user.admin_of_schools}
    end
    has_permission_on :slide_timers, :to => [:manage] do
      if_attribute :school_id => is_in {user.admin_of_schools}
    end
    has_permission_on :displays, :to => :manage do
      if_attribute :puavo_id => is_in {user.admin_of_schools}
    end
  end
end

privileges do
  privilege :manage do
    includes :create, :read, :edit, :update, :destroy, :new, :delete
  end
  privilege :read do
    includes :index, :show
  end
end
