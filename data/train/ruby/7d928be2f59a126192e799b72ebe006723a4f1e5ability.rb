class Ability
  include CanCan::Ability

  def initialize(user)
		@user = user || User.new # for guest (not logged in)
		
		alias_action :read, :create, :update, :destroy, :to => :crud
		
		if @user.superadmin?
			can :manage, :all
		else
			guest
			any_user unless @user.username.blank?
			@user.roles.each { |role| send(role.name.underscore.tr(' ', '_')) }
		end
  end
	
private
	def guest
		can :manage, 		:static_page
		can :create, 		:session
		can :manage, 		:password_reset
		can :create, 		Account
	end

	def any_user
		can :destroy, 	:session
		can :create, 		:password
		can :read, 			:dashboard
		
		# Read own Employee Profile
		can :read, 			Person, id: @user.person_id
		can :show, 			Employee, person: { id: @user.person_id }
		can :manage, 		Address, addressable_type: 'Person', addressable_id: @user.person_id
		can :manage, 		Phone, phoneable_type: 'Person', phoneable_id: @user.person_id
		can :read,			:employment
		can :read,			:biography
	end
	
	def manage_employees
		can :read, 			Person
		can :manage,		Employee
		cannot :destroy,Employee
		can :manage, 		Address, addressable_type: 'Person'
		can :manage, 		Phone, phoneable_type: 'Person'
		can [:read, :update],		:employment
		can [:read, :update],		:biography
	end
	
	def manage_logins
		can :read, 			Person
		can :read, 			Employee
		can :manage, 		User
	end
	
	def manage_locations
		can :manage, 		Location
	end
	
	def manage_seasons
		can :manage, 		Season
	end
	
	def manage_pieces
		can :manage, 		Piece
		can :manage, 		Character
		can :manage, 		Scene
	end
	
	def manage_agma_contract
		can [:read, :update], 	AgmaContract
		can [:read, :update],		:contract_rehearsal_week
		can [:read, :update],		:contract_company_class
		can [:read, :update],		:contract_costume_fitting
		can [:read, :update],		:contract_lecture_demo
		can :manage, 		RehearsalBreak
	end
	
	def schedule_company_classes
		can :manage,		Event, schedulable_type: 'CompanyClass'
		can :manage, 		CompanyClass
		can :create, 		:current_season
		can [:read, :create], 	:invitees
		can :manage,		:selected_events
		can :read, 			:warnings_report
	end
	
	def schedule_costume_fittings
		can :read,			Event, schedulable_type: 'CostumeFitting'
		can :manage, 		CostumeFitting
		can :create, 		:current_season
		can :read, 			:warnings_report
	end
	
	def schedule_rehearsals
		can :read,			Event, schedulable_type: 'Rehearsal'
		can :manage, 		Rehearsal
		can :create, 		:current_season
		can :read, 			:warnings_report
	end
	
	def schedule_lecture_demos
		can :read,			Event, schedulable_type: 'LectureDemo'
		can :manage, 		LectureDemo
		can :create, 		:current_season
		can :read, 			:warnings_report
	end
	
	def manage_casts
		can :read, 			Season
		can :read, 			SeasonPiece
		can :manage, 		Cast
		cannot [:create, :update, :destroy], 	Cast, season_piece: { published: true }
		can :manage, 		Casting
		cannot [:create, :update, :destroy], 	Casting, cast: { season_piece: { published: true } }
		can :update, 		:publish_cast
	end
	
	def manage_account
		can [:read, :update], 	Account, id: @user.account_id
		can :manage, 						Address, addressable_type: 'Account', addressable_id: @user.account_id
		can :manage, 						Phone, phoneable_type: 'Account', phoneable_id: @user.account_id
		can :manage, 						:payment
		can :manage, 						:subscription
	end
	
	def administrator
		manage_account
		manage_agma_contract
		manage_employees
		manage_logins
		manage_locations
		manage_seasons
		manage_pieces
		schedule_company_classes
		schedule_costume_fittings
		schedule_rehearsals
		schedule_lecture_demos
		manage_casts
	end
end
