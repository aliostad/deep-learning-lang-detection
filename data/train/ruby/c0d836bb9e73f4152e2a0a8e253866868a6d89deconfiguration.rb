module Makenewsmail
  class Configuration
    include HTTParty

    def initialize(api_user, api_key)
      @api_user = api_user
      @api_key = api_key
      self.class.format :xml
      self.class.base_uri "https://api.makenewsmail.com"
    end

protected

    def post_xml(xml, path)
      self.class.post( path, 
        body: xml.strip, 
        headers: {'Content-Type' => "text/xml; charset=utf-8"} ,
        basic_auth: {username: @api_user, password: @api_key}
      )
    end
    
    def get_xml(path)
      self.class.get( path, 
        basic_auth: {username: @api_user, password: @api_key}
      )
    end
  end
end