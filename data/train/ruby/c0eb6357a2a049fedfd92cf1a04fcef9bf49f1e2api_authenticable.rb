require 'active_support/concern'

module ApiAuthenticable
	extend ActiveSupport::Concern
	
	included do
		#associations
		has_one :api_credential, as: :api_authenticable, dependent: :destroy

		#callbacks
		after_create :create_api_credential
		after_rollback :destroy_api_credential, on: :create
	end
	
	def authenticate(secret)
		self.api_credential.validate_secret(secret)
	end

	module ClassMethods
		def find_by_api_id(api_id)
			self.joins(:api_credential).where("api_credentials.api_id = ?", api_id)
		end
	end
	
	private
	
	def create_api_credential()
		api_cred = ApiCredential.new()
		api_cred.api_authenticable = self
		api_cred.save!
	end

	def destroy_api_credential()
		return if self.api_credential.nil?
		self.api_credential.destroy
	end
end
