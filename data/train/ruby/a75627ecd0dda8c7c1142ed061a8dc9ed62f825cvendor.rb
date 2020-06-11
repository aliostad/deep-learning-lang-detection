class Vendor
  attr_accessor :api_password
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :api_key
  field :api_password_salt
  field :api_password_hash
  
  has_many :authorizations
  has_many :projects

  validates_presence_of :name, :api_key

  before_save :encrypt_password

  def encrypt_password
    if api_password.present?
      self.api_password_salt = BCrypt::Engine.generate_salt
      self.api_password_hash = BCrypt::Engine.hash_secret(api_password, api_password_salt)
    end
  end

  def self.authenticate(api_key, api_password)
    vendor = Vendor.where(api_key: api_key).first
    if vendor && vendor.api_password_hash == BCrypt::Engine.hash_secret(api_password, vendor.api_password_salt)
      vendor
    else
      nil
    end
  end
end
