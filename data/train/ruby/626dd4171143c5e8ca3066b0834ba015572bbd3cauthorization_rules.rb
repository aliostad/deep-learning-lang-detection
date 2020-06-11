authorization do
    role :admin do
        has_permission_on [:people], :to => [:manage]
        has_permission_on [:movies], :to => [:manage]
        has_permission_on [:rents], :to => [:manage]
        has_permission_on [:roles], :to => [:manage]
    end

    role :client do
        has_permission_on [:movies], :to => [:read]
    end

    role :guest do
    end
end

privileges do
    privilege :manage, :includes => [:index, :show, :new, :create, :edit, :update, :destroy]
    privilege :read, :includes => [:index, :show] 
    privilege :create, :includes => [:new]
    privilege :update, :includes => [:edit]
    privilege :delete, :includes => [:destroy]
end