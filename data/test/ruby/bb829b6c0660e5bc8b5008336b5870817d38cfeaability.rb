class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    end

    can :manage, Document do |doc|
      doc.user == user
    end

    can :manage, Folder do |folder|
      folder.user == user
    end

    can :add_subject, University do |univer|
      user.universities.include? univer
    end

    can :manage, Document do |resource|
      resource.user == user
    end

    can :manage, Folder do |resource|
      resource.user == user
    end
    
  end
end
