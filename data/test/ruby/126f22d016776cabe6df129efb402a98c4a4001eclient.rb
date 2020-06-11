module VoterRegApi
  
  class Client
    include HTTParty
    
    format :json
    base_uri 'https://register.barackobama.com' 


    def self.config
      config_file = File.join(File.dirname(__FILE__),'..','config','client.yml')
      YAML.load_file(config_file)[Rails.env]
    end
    
    def self.api_key=(api_key)
      @@api_key = api_key
    end

    def self.api_key
       @@api_key = @@api_key || config['api_key']
    end
    
    def api_key
      Client.api_key
    end

    def voterreg_uri(env)   
       'https://register.barackobama.com'
    end
  end
end