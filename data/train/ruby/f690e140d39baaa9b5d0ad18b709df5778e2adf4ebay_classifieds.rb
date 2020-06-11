require 'logger'
module EbayClassifieds
  @@api_url = "http://webapi.ebayclassifieds.com/webapi"
  @@api_username = 'TEST'
  @@api_password = 'TEST'  
  
  def self.api_url
    @@api_url
  end
  def self.api_url=(u)
    @@api_url = u
  end
  def self.api_username
    @@api_username
  end
  def self.api_username=(u)
    @@api_username = u
  end
  def self.api_password
    @@api_password
  end
  def self.api_password=(p)
    @@api_password=p
  end
  def self.logger=(l)
    @@logger = l
  end
  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end
end