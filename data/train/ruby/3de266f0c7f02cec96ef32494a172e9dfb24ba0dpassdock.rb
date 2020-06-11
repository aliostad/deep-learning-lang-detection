gem 'httparty'

module Passdock
  include HTTParty
  @@api_base = 'https://api.passdock.com/api/v1/'
  @@api_key = nil
  
  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end
  
  def self.api_base=(api_base)
    @@api_base = api_base
  end

  def self.api_base
    @@api_base
  end
  
  def self.templates
    self.get("#{@@api_base}/templates.json?api_token=#{@@api_key}")
  end
  
  def self.template(id)
    self.get("#{@@api_base}/templates/#{id}.json?api_token=#{@@api_key}")
  end
  
  def self.destroy_template(family_id, errors)
    _errors = errors ? "true" : "false"
    options = {
      :body => {
        :errors => _errors,
        :api_token => @@api_key
      }
    }  
    self.delete("#{@@api_base}/templates/#{family_id}.json", options)      
  end 
  
  def self.pass(pass_id, family_id)
    self.get("#{@@api_base}/templates/#{family_id}/passes/#{pass_id}.json?api_token=#{@@api_key}")
  end
  
  def self.download_pass(pass_id, family_id)
    self.get("#{@@api_base}/templates/#{family_id}/passes/#{pass_id}.json?api_token=#{@@api_key}&show=true")
  end
  
  def self.create_pass(pass, family_id, debug, errors)
    _debug = debug ? "true" : "false"
    _errors = errors ? "true" : "false"
    options = {
      :body => {
        :debug => _debug,
        :errors => _errors,
        :api_token => @@api_key,
        :pass => pass
      }
    }  
    self.post("#{@@api_base}/templates/#{family_id}/passes.json", options)      
  end  
  
  def self.update_template(template, family_id, debug, errors)
    _debug = debug ? "true" : "false"
    _errors = errors ? "true" : "false"    
    options = {
      :body => {
        :debug => _debug,
        :errors => _errors,
        :api_token => @@api_key,
        :family => template
      }
    }  
    self.put("#{@@api_base}/templates/#{family_id}.json", options)      
  end  

  def self.update_pass(pass, pass_id, family_id, debug, errors)
    _debug = debug ? "true" : "false"
    _errors = errors ? "true" : "false"    
    options = {
      :body => {
        :debug => _debug,
        :errors => _errors,
        :api_token => @@api_key,
        :pass => pass
      }
    }  
    self.put("#{@@api_base}/templates/#{family_id}/passes/#{pass_id}.json", options)      
  end  

  
  def self.destroy_pass(pass_id, family_id, errors)
    _errors = errors ? "true" : "false"
    options = {
      :body => {
        :errors => _errors,
        :api_token => @@api_key
      }
    }  
    self.delete("#{@@api_base}/templates/#{family_id}/passes/#{pass_id}.json", options)
  end    
end