# note: role inheritence implemented via Ryan Bates' method
# outlined in https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
module Virgo
  class Ability
    include CanCan::Ability

    def initialize(user)
      @user = user || User.new # for guest

      send(@user.role) if @user.role.present?
    end

    def anonymous
      can :read, Post do |post|
        post.published? && post.live
      end
    end

    def normal
      anonymous
    end

    def editor
      can :manage, :all
      can :manage, Virgo::User do |u|
        u == @user
      end
      cannot :index, Virgo::User
    end

    def contributor
      can :manage, Virgo::Post do |post|
        post.author == @user
      end

      can :manage, Virgo::Slideshow do |slideshow|
        slideshow.author == @user
      end

      can :manage, Virgo::Slide do |slide|
        can?(:manage, slide.slideshow)
      end

      can :read, Virgo::Post

      cannot :manage, Virgo::User
      cannot :manage, Virgo::Column
      cannot :manage, Virgo::Site
    end

    def admin
      can :manage, :all
    end

    def superuser
      can :manage, :all
    end
  end
end
