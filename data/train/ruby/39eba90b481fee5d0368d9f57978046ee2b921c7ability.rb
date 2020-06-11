class Ability
  include CanCan::Ability
  
  def initialize(user)
    # alias_action :manage, :to => :read
    user.permissions.each do |permission|
      # if permission.subject_id.nil?
      can permission.ability_name.to_sym, permission.resource_name.singularize.constantize
      # else
      #   can permission.action.to_sym, permission.subject_class.constantize, :id => permission.subject_id
      # end
    end
    
    #ToDo: Finish this!
    
    if user.has_role?('financial')
      can :manage, Batch
      can :manage, Donation
      can :manage, Contribution
    end
    
    if user.has_role?('checkin_user')
      can :manage, :checkin
    end
    
    if user.has_role?('admin')
      can :manage, :all
    end
    
    # unless user.has_role?('confidential')
    #   cannot :read, Contact do |contact|
    #     contact.contact_type.confidential?
    #   end
    # end
    
  end
  
end