# Roles for declarative_authorization

# roles table in db:
# '1', 'superuser'
# '2', 'admin'
# '3', 'editor'
# '4', 'system_user'

authorization do

  role :base do
    # Signed in users will have a user_profiles page.
    has_permission_on :user_profiles, :to => [:show]
  end

  role :superuser do
    includes :base
    has_permission_on :user_profiles, :to => [:manage, :manage_roles]
    has_permission_on :news_articles, :to => [:manage]
    has_permission_on :meetings,      :to => [:manage]
    has_permission_on :pages,         :to => [:manage]
  end

  role :admin do
    includes :base
    has_permission_on :user_profiles, :to => [:read]
    has_permission_on :news_articles, :to => [:manage]
    has_permission_on :meetings,      :to => [:manage]
    has_permission_on :pages,         :to => [:manage]
  end

  role :editor do
    includes :base
  end

  role :system_user do
    includes :base
  end

end

privileges do
  # Default privilege hierarchies to facilitate RESTful Rails apps.
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy

  # Others
  privilege :manage_roles, :includes => :update_roles
end

