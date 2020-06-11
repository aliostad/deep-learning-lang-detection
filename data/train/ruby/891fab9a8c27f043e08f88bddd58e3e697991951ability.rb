class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, :all if user.is?(:admin)

    can :manage, User, :id => user.id

    can :manage, Authentication, :user_id => user.id

    can :manage, Website, :user_id => user.id
    can :read, Website, ["websites.id in (select shares.resource_id
                                        from shares
                                        where shares.resource_type = 'Website'
                                        and shares.receiver_id = '#{user.id}')"] do |ws|
      ws.shares.map(&:receiver).include?(user) #TODO optimize
    end

    can :manage, Crawl do |crawl|
      can? :manage, crawl.website
    end

    can :manage, ServerLog do |sl|
      can? :manage, sl.website
    end

    can :manage, Share, :owner_id => user.id

  end
end
