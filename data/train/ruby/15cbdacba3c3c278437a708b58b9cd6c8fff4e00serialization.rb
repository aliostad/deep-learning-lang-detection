module Rico
  module Serialization
    Config = {
      :provider => Marshal,
      :api => { :serialize => :dump, :deserialize => :load }
    }    
    
    def self.provider=(prov)
      config[:provider] = prov
    end
    
    def self.api=(api_h)
      validate_api(api_h)
      config[:api] = api_h
    end

    def self.validate_api(api={})
      unless api.include?(:serialize) && api.include?(:deserialize)
        raise "Unknown api methods, define [:serialize, :deserialize] to use Rico with a non-standard serialization provider"
      end
    end

    def self.[](*api_args)      
      api_method = api_args.slice!(0)
      
      case
      when config[:api][api_method].respond_to?(:call)
        config[:api][api_method].call(*api_args)
      when config[:provider].respond_to?(config[:api][api_method])
        config[:provider].send(config[:api][api_method], *api_args)
      else
        raise "Unknown method: #{api_method} for provider: #{config[:provider]}"
      end
    end  
    
    def self.config
      unless self == Rico::Serialization
        raise "Define 'self.config' that returns custom provider and api if using non-standard serialization provider"
      end   
      
      return Config
    end
  end
end
