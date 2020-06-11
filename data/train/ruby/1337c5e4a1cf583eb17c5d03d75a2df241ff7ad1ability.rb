#coding: utf-8
# ROLES = %w[admin-管理员 issue-发行部 advertising-广告部 design-设计部 layout-排版组 purchase-采购部 acc-财会部]

class Ability

	include CanCan::Ability

	def initialize(user)
		# Define abilities for the passed in user here. For example:
		#
		user ||= User.new # guest user (not logged in)

		if user.role == "admin-管理员"
			can :manage, :all
		end

		if user.role == "issue-发行部"
			can :view, :issue
			can :manage, :issue_areas
			can :manage, :issue_customers
			can :manage, :issue_customer_types
			can :manage, :issue_publish  
			can :manage, :issue_return 
		end	

		if user.role =="rimes"
			can :manage,:rimes
		end
	
		if user.role =="advertising-广告部"
			can :view, :advertising
			can :manage, :advertising_types  
			can :manage, :advertising_sizes  
		end

		if user.role == "design-设计部"
			can :view, :design
		end

		if user.role == "layout-排版组"
			can :view, :layout
		end

		if user.role == "acc-财会部"
			can :view, :issue
			can :view, :issue_areas
			can :view, :issue_customers
			can :view, :issue_customer_types
			can :view, :issue_publish  
			can :view, :issue_return 
			can :set, :issue_price 
		end	
	end
end
