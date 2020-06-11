class Organization < ActiveRecord::Base
	has_many :users
	has_many :organization_clients
	has_many :organization_profiles
	has_many :profiles, through: :organization_profiles
	has_many :clients, through: :organization_clients
	has_many :subscriptions
	attr_accessor :admin
	def causes
		Cause.joins(users: :organization).where(organizations: {id: self.id})
	end
	def clients
		Client.joins(causes: {users: :organization}).where(organizations: {id: self.id}).distinct
	end

	def open_causes
		self.causes.reject{|c| c.state.id==6}
	end

	def set_profiles
		causas = Subject.find_by class_name: 'Cause'
		avances = Subject.find_by class_name: 'JournalEntry'
		pagos = Subject.find_by class_name: 'Payment'
		manage = Action.find_by name: 'manage'
		manage_causes = Permission.find_by_subject_id_and_action_id causas.id, manage.id
		manage_je = Permission.find_by_subject_id_and_action_id avances.id, manage.id
		manage_payments = Permission.find_by_subject_id_and_action_id pagos.id, manage.id

		self.admin = Profile.create long_name: 'Administrador', name: 'admin', permissions: [manage_causes, manage_je, manage_payments]
		lawyer = Profile.create long_name: 'Abogado', name: 'lawyer', permissions: [manage_causes, manage_je]
		executive = Profile.create long_name: 'Ejecutivo', name: 'executive', permissions: [manage_payments]

		self.profiles = [admin, lawyer, executive]
		self.save!
	end

	def op
		OrganizationProfile.find_by_organization_id_and_profile_id id, admin.id
	end
end
