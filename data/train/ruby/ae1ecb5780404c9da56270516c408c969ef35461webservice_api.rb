class Modelos::WebserviceApi < ActionWebService::API::Base
    
    api_method :hello, :returns => [:string], :expects => [:string]
    
    api_method :get, :returns => [:string], :expects => [{:acronimo => :string}]
    
    api_method :list, :returns => [:string]
    
    api_method :listimplementaciones, :returns => [:string]
    
    api_method :ejecutar, :returns => [:string], :expects => [{:acronimo => :string},{:parametros => :string}]
    
    api_method :parametrosejecucion, :returns => [:string], :expects => [{:acronimo => :string}]    
    
end
