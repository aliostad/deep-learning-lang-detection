module Api
	module V1
		class ApiController < ApplicationController
			respond_to :json
			skip_before_filter :protect_from_forgery
			before_action :identify

			private
			def get_api_id
				request.headers['X-Api-Id']
			end
			
			def get_api_secret
				request.headers['X-Api-Secret']
			end

			def identify
				api_id = get_api_id
				api_cred = ApiCredential.where("api_id = ?", api_id).first if api_id
				unless api_cred
					head status: :unauthorized
					return false
				end
				@api_client = ClientApplication.find_by_api_id(api_id).first
			end

			def authenticate
				secret = get_api_secret
				unless secret
					head status: :unauthorized
					return false	
				end
				@api_client.api_credential.validate_secret(secret)
			end

			def check_approval
				@api_client.approved?
			end
		end
	end
end
