class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user and user.candidate
      # can :manage, Response do |response|
      #   response.candidate == user.candidate
      # end
    end

    if user and user.reviewer
      can :read, Candidate do |candidate|
        candidate.reviewers.include?(user.reviewer)
      end
    end

    if user and user.is_admin?
      can :manage, Candidate
      can :manage, CandidateReviewer
      can :manage, Reviewer
      can :manage, Milestone
      can :manage, Question
      can :manage, Status
      # can :manage, Response
    end

  end
end
