require 'uuidtools' 

class Api < ActiveRecord::Base
  attr_accessible :key, :secret

  def self.generate(member_id)
  	api = Api.new
  	api.key = UUIDTools::UUID.random_create.to_s.gsub('-','')
  	api.secret = UUIDTools::UUID.random_create.to_s.gsub('-','')
    api.member_id = member_id
  	api.save
  	return api
  end

  def self.auth(key,secret)
  	begin
  		api = Api.find_by_key key
  		if api.secret == secret
  			return true
  		else
  			return false
  		end
  	rescue => err 
  		p err
  		return false
  	end
  end
end
