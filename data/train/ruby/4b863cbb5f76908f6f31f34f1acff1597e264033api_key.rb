# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  api_key    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# ApiKey model
#
class ApiKey < ActiveRecord::Base
  has_one :user

  validates_presence_of :api_key
  validates_uniqueness_of :api_key

  def self.generate(user)
    begin
      api_key_uuid = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key_uuid)

    api_key = user.api_key
    api_key.api_key = api_key_uuid

    api_key.save!
  end
end
