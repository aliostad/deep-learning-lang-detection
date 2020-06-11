require 'open-uri'




class Person

  def email(email, api_key, format=nil)
    if format == 'xml'
      open("http://api.fliptop.com/beta/person?email=#{email}&api_key=#{api_key}&format=xml")
    else
      open("http://api.fliptop.com/beta/person?email=#{email}&api_key=#{api_key}")
    end
    rescue
      nil
  end

  def twitter(handle, api_key, format=nil)
    if format == 'xml'
      open("http://api.fliptop.com/beta/person?twitter=#{handle}&api_key=#{api_key}&format=xml")
    else
      open("http://api.fliptop.com/beta/person?twitter=#{handle}&api_key=#{api_key}")
    end
    rescue
      nil
  end

  def facebook(profile, api_key, format=nil)
    if format == 'xml'
      open("http://api.fliptop.com/beta/person?facebook=#{profile}&api_key=#{api_key}&format=xml")
    else
      open("http://api.fliptop.com/beta/person?facebook=#{profile}&api_key=#{api_key}")
    end
    rescue
      nil

  end
end
