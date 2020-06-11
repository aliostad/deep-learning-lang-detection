class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new # guest user

		# give admin permission to all
		#can :manage, :all
		#return

		can :read, [Competition]
		can [:read, :edit, :update], [User], :_id=>user.id
		can :manage, Participant

#p db.roles.findOne()

		if user.new_record?
		   p "sdf"
			#cannot :manage, Participant
		elsif user.role? :admin
				  p "sdf1"
			can :manage, :all
			can :assign_roles, User
		elsif user.role? :moderator
				  p "sdf2"
			can :manage, [Competition]
		else
				  p "sdf3"
			# manage products, assets he owns
			%Q{
			can :manage, Product do |product|
				product.try(:owner) == user
			end
			can :manage, Asset do |asset|
				asset.assetable.try(:owner) == user
			end
			}
		end
	end
end