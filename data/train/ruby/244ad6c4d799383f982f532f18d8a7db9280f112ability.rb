class Ability
  include CanCan::Ability

  def initialize(user)
    can(:manage, user)
    add_mission_rules!(user)
    add_participant_rules!(user)
    add_deliverable_rules!(user)
    add_requirement_rules!(user)
  end

  private

  def add_deliverable_rules!(user)
    can(:manage, Deliverable) do |deliverable|
      deliverable.mission.users.none?
    end

    return unless user

    can(:manage, Deliverable) do |deliverable|
      deliverable.mission.users.include?(user)
    end
  end

  def add_requirement_rules!(user)
    can(:manage, Requirement) do |requirement|
      requirement.mission.users.none?
    end

    return unless user

    can(:manage, Requirement) do |requirement|
      requirement.mission.users.include?(user)
    end
  end

  def add_participant_rules!(user)
    can(:manage, Participant) do |participant|
      participant.joinable.users.none?
    end

    return unless user

    can(:manage, Participant) do |participant|
      participant.joinable.users.include?(user)
    end
  end

  def add_mission_rules!(user)
    can(:read, Mission, { public: true })
    can(:manage, Mission) do |mission|
      mission.users.none?
    end

    return unless user

    can(:manage, Mission) do |mission|
      mission.users.include?(user)
    end
  end
end
