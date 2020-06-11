class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new(role: :guest)
    send(@user.role)
  end

  def guest
    can :read, Page
    can :home, Page
    can :read, Post if Setting.enable_blog
    can :read, Comment
  end

  def user
    guest
    can :create_comment, Post, allow_commentaries: true
    can :create, Comment
  end

  def admin
    user
    can :manage, Page
    can :manage, Post if Setting.enable_blog
    cannot :create_comment, Post, allow_commentaries: false
    can :manage, Image
    can :manage, Attachment
    can :manage, Snippet
    can :manage, Setting
    can :manage, User
    cannot :update, User, id: @user.id
    cannot :destroy, User, id: @user.id
  end
end
