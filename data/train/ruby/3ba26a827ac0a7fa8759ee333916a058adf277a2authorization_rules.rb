authorization do
    role :admin do
        # ROLES
        has_permission_on [:admin_comments], :to => [:manage]
        has_permission_on [:admin_pages], :to => [:manage, :welcome]
        has_permission_on [:admin_users], :to => [:manage]
        has_permission_on [:admin_categories], :to => [:manage]
        has_permission_on [:admin_posts], :to => [:manage]
    end

    role :editor do
        # ROLES
        has_permission_on [:admin_pages], :to => [:welcome]
        has_permission_on [:admin_posts], :to => [:manage]
    end

    role :client do
        # ROLES
    end



    role :guest do
        # ROLES
        has_permission_on [:pages], :to => [:read]
    end
end

privileges do
    privilege :manage, :includes => [:index, :show, :new, :create, :edit, :update, :destroy]
    privilege :read,   :includes => [:index, :show]
    privilege :create, :includes => [:new]
    privilege :update, :includes => [:edit]
    privilege :delete, :includes => [:destroy]
end