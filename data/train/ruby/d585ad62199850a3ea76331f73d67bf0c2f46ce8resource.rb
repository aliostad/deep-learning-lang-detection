module Capacity
  class Resource
    
    def initialize( name, token = nil )
      @name = name.to_sym
      @api = API.new
      @api.token = token
    end
    
    def token=( t )
      @api.token = t
    end
    
    def token
      @api.token
    end
    
    def get( params = {} )
      @api.get( @name, params )
    end
    
    def put( params = {} )
      @api.put( @name, params )
    end
    
    def post( params = {} )
      @api.post( @name, params )
    end
    
    def delete( params = {} )
      @api.delete( @name, params )
    end
    
  end
end