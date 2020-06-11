#######################################################################  
# ApiTalk
#######################################################################  
module ApiTalk
  # Calls assembla API
  # @params: api(string)
  # @return: json(success), nil(error)
  def ApiTalk::callAPI(api)
    uri = AppConfig::pm_config['url']+'/'+AppConfig::pm_config['version']+'/'+api
    request_data  = {}
    begin
      #TODO Uncomment these lines before DEMO
    request_data  = HTTParty.get(uri, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 
                  "X-Api-Key" => AppConfig::pm_config['api_key'], "X-Api-Secret" => AppConfig::pm_config['api_secret_key']} )
    rescue
      if request_data.response.code != "200"
        # flash[:alert] = request_data.response.code + " - " + request_data.response.message
        raise "Something went wrong"
        Rails.logger("API call failed to #{uri}. Response returned is #{request_data.response.code} - request_data.response.message")
      end

    end
    request_data
  end 

  #######################################################################
  # All Methods for Space
  #######################################################################
  class Space
  
    # Get all spaces using configure PM Tool and API configs
    def self.getSpace(space_id, api='spaces')
      ApiTalk::callAPI(api+'/'+space_id)
    end

    # Get all spaces using configure PM Tool and API configs
    def self.getSpaces(api='spaces')
      ApiTalk::callAPI(api)
    end

    # Get Space members for space
    # @param space_id
    def self.getMembers(space_id, api='spaces')
      api += "/#{space_id}/user_roles"
      # binding.pry
      ApiTalk::callAPI(api)
    end

  end 

  #######################################################################
  # All Methods for User
  #######################################################################
  class User
    # Get user name by ID
    def self.getName(id, api = 'users')
      ApiTalk::callAPI("#{api}/#{id}")
    end

  end

  #######################################################################
  # All Methods for Stream
  #######################################################################
  class Stream
    # Get activity stream
    def self.getActivity(api='activity')
      ApiTalk::callAPI(api)
    end

  end



end