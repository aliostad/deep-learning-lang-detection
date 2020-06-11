require 'nixus_api'
require 'nixus_security'

class ApiCredential < ActiveRecord::Base
	#validations:
	validate :api_id_cannot_be_changed, on: :update
	validate :api_secret_hash_cannot_be_changed, on: :update
	validates :api_authenticable,
		presence: { message: :blank }
	validates :api_authenticable_id,
		uniqueness: { unless: 'api_authenticable.nil?' }	
	validates :api_id,
		presence: { message: :blank },
		length: { :is => NixusAPI::ID_SIZE, unless: 'api_id.blank?' },
                format: { :with => /[A-Z0-9]{#{NixusAPI::ID_SIZE}}/, :message => :invalid, unless: 'api_id.blank?'},
                uniqueness: { unless: 'api_id.blank?' },
		on: :create

        validates :api_secret_hash,
		length: { :is => NixusAPI::SECRET_HASH_SIZE, unless: 'api_secret_hash.blank?' }
	#callbacks:
	after_initialize :set_api_id
	#associations:
	belongs_to :api_authenticable, polymorphic: true

        #methods:
        
        def set_api_secret
		return nil unless self.api_secret_hash.blank?
                api_secret = NixusAPI::generate_new_secret()
                if self.update_attribute(:api_secret_hash, NixusAPI::get_secret_hash(self.api_id, api_secret))
	                return api_secret
		else
			return nil
		end
        end
	
	def validate_secret(secret)
		self.api_secret_hash == NixusAPI::get_secret_hash(self.api_id, secret)
	end

        private
        def set_api_id
		begin
			id = NixusAPI::generate_new_id()
		end while self.class.exists?(api_id: id)
                self.api_id ||= id
        end

        def api_id_cannot_be_changed()
                return unless api_id_changed?
                errors.add :api_id, I18n.t('errors.messages.read_only', :attribute=>"api_id")
        end
        
	def api_secret_hash_cannot_be_changed()
                return unless api_secret_hash_changed?
                errors.add :api_secret_hash, I18n.t('errors.messages.read_only', :attribute=>"api_secret_hash")
        end
end
