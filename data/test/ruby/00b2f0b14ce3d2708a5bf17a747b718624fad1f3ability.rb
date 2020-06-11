class Ability
	include CanCan::Ability
	
	def initialize(user)

		if user.kind_of? AdminUser
			can :read, ActiveAdmin::Page, :name => "Dashboard"
			can :manage, BankAccount
			can :manage, Order
			can :manage, TrainingLocation
			can :manage, TrainingSchedule
			can :manage, TestResult
			can :manage, Payment
			can :manage, PostTest

			if user.is_super_admin?
				can :manage, Training
				can :manage, Attendee
				can :manage, AdminUser
				can :manage, Campus
				can :manage, Event
				can :manage, News
				can :manage, Blog
				can :manage, Pretest
				can :manage, PaymentType
				can :manage, Profile
			else
				can :manage, Training, Training.joins(:training_location).where("training_locations.id in (?)", user.authorized_locations.map(&:id)) do |training|
					user.authorized_locations.map(&:id).include?training.training_location.id
				end
				can [:update, :list, :read], Attendee, Attendee.by_training_locations(user.authorized_locations.map(&:id)) do |attendee|
					Attendee.by_training_locations(user.authorized_locations.map(&:id))
				end
				can :create, Attendee

			end
		elsif user.kind_of? Attendee
			can :read, Attendee do |a|
				a.id == user.id
			end
		end

	end
		
end