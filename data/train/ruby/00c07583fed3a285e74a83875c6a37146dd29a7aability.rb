module Rhinobook
	module Ability
		extend ActiveSupport::Concern    
		included do
			alias_method_chain :initialize, :rhinobook
		end

		def initialize_with_rhinobook(user)

			user ||= Rhinoart::User.new
			initialize_without_rhinobook(user)

			return if !user.approved? or !user.admin?

			if user.has_admin_role?(Rhinoart::User::ADMIN_PANEL_ROLE_BOOK_MANAGER)
				can :manage, :books
			end

			if user.has_admin_role?(Rhinoart::User::ADMIN_PANEL_ROLE_BOOK_CREATOR)
				can :manage, :books
				can :manage, :create_docs				
			end

			if user.has_admin_role?(Rhinoart::User::ADMIN_PANEL_ROLE_BOOK_EDITOR)
				can :manage, :books
				can :manage, :create_docs
				can :manage, :edit_docs
			end

			if user.has_admin_role?(Rhinoart::User::ADMIN_PANEL_ROLE_BOOK_AUTHOR) ||
				user.has_admin_role?(Rhinoart::User::ADMIN_PANEL_ROLE_BOOK_PUBLISHER) 

				can :manage, :books
				can :manage, :create_docs
				can :manage, :edit_docs
				can :manage, :public_docs
			end			
		end
	end
end




