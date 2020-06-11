#
# judge.me
#  This client require rest_client and yaml gem
# 		Author: Fabian Ramirez <framirez(at)acid.cl>
# 		Date: 20-JUN-2012

require 'yaml'
require 'rest_client'

module APIJudgeme
  
  # Variables
  API                 = YAML::load(File.open("jugdeme.yml"))['development']
  JUDGEME_API_KEY     = API['api_key']
  JUDGEME_API_URL     = API['api_url']
  JUDGEME_API_FORMAT  = [".", API['format']].join("")

	# Case Class
	class Case
		# New Case(full_payment,)
		def self.new(object_new_case)
			object_new_case[:api_key] = JUDGEME_API_KEY
			request = RestClient.post [JUDGEME_API_URL, '/api/v1/cases', JUDGEME_API_FORMAT].join(""), object_new_case
			p request
		end

		def self.list
			request = RestClient.get [JUDGEME_API_URL, '/api/v1/cases', JUDGEME_API_FORMAT].join(""), {:params => {:api_key => JUDGEME_API_KEY} }
			p request
		end

		def self.show(auth_key)
			request = RestClient.get [JUDGEME_API_URL, '/api/v1/cases/', auth_key, JUDGEME_API_FORMAT].join(""), {:params => {:api_key => JUDGEME_API_KEY} }
			p request
		end

	end

  # Messages Class
	class Message

		def self.list(auth_key)
			request = RestClient.get [JUDGEME_API_URL, '/api/v1/cases/', auth_key, "/messages", JUDGEME_API_FORMAT].join(""), {:params => {:api_key => JUDGEME_API_KEY} }
			p request
		end

	end

end

=begin
  # Create the Case Object
  cases_object_api = APIJudgeme::Case

  	# New Case
  	cases_object_api.new({
  			:full_payment => true,
  			:case => {
  				:summary => "This is an example from the API"
  			},
  			:filer => {
  				:first_name => "Jorge",
  				:last_name => "Silva",
  				:email => "example@mail.com",
  				:business => true,
  				:business_name => "judge.me",
  				:buyer => false
  			},
  			:responder => {
  				:first_name => "Fabian",
  				:last_name => "Ramirez",
  				:email => "example@test.com",
  				:business => false
  			}
  	  })

  	# List Cases
  	#cases_object_api.list

=end