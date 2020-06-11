class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= AdminUser.new
    #if (user.admin_permission == "社团主席")
    #  can :read, [User, Issue]
    #end
    #
    #if (user.admin_permission == "超级管理员")
    #  can :manage, :all
    #end
    #
    #if (user.admin_permission == "社联委员")
    #  can :manage, :all
    #  cannot :manage, AdminUser
    #end
    #
    case user.admin_permission.to_s
      when "超级管理员" #SuperAdmin
        can :manage, :all
      when "社联委员" #Admin
                  #can :manage, :all
        can :read, ActiveAdmin::Page, :name => "Dashboard"


        can :manage, AdminUser, :id => user.id
        cannot :destroy, AdminUser

        can :manage, Category
        can :manage, Department
        can :manage, Member
        can :manage, HomeBackground
        can :manage, Issue
        can :manage, Noti
        can :manage, User
        can :manage, Material
        can :manage, Member

        can :manage, Society
        cannot :destroy, Society
        cannot :update, Society

        can :manage, Faq
        can :manage, SubFaq
        can :manage, IssueImage
        can :manage, ActiveAdmin::Comment


      when "社团主席" #Teacher
        can :read, ActiveAdmin::Page, :name => "Dashboard"


        can :manage, Comment


        can :manage, AdminUser, :id => user.id
        cannot :destroy, AdminUser, :id => user.id

        can :manage, Member
        cannot :destroy, Member

        can :manage, Society, :id => user.society_id
        can :update, Society
        cannot :destroy, Society

        can :manage, Issue, :society_id => user.society_id
        can :create, Issue
        #cannot :destroy, Issue

        can :manage, Noti, :society_id => user.society_id
        can :create, Noti

        #cannot :destroy, Noti

        can :manage, IssueImage, :society_id => user.society_id
        can :create, IssueImage


        can :manage, Material
        cannot :destroy, Material

        can :manage, Faq
        cannot :destroy, Faq

        can :manage, SubFaq
        cannot :destroy, SubFaq

        can :manage, User, :id => user.society_id
        can :create, User
        #cannot :update, User
        #cannot :destroy, User

        can :manage, Department
        cannot :update, Department
        cannot :destroy, Department


        cannot :manage, [Category, SlDepartment, HomeBackground]

      #
      #when "社联委员" && (user.sl_department.to_s == "公益实践中心" || user.sl_department.to_s == "文娱兴趣中心" || user.sl_department.to_s == "体育竞技中心"|| user.sl_department.to_s == "学术科技中心")
      #  can :read, ActiveAdmin::Page, :name => "Dashboard"
      #
      #  can :manage, AdminUser, :id => user.id
      #  cannot :destroy, AdminUser
      #
      #  can :manage, Category
      #  can :manage, Department
      #  can :manage, Member
      #  can :manage, HomeBackground
      #  can :manage, Issue
      #  can :manage, User
      #  can :manage, Material
      #  can :manage, Member
      #
      #  can :manage, Society, :department_id.to_s =>
      #  cannot :destroy, Society
      #
      #  can :manage, Faq
      #  can :manage, SubFaq
      #  can :manage, IssueImage


    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
