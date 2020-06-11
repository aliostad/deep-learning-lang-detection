# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  api_key    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  before :each do
    before_each 'apiKeyModel'
  end

  describe 'valid generate api key' do
    it 'is valid generate api key' do
      api_key = ApiKey.find(@user.api_key_id)

      ApiKey.generate @user

      new_api_key = @user.api_key
      expect(new_api_key.api_key).to_not eq(api_key.api_key)
    end
  end
end
