require 'rails_helper'

RSpec.describe ApiCall, type: :model do

  it { should belong_to :api_key }

  describe ApiCall, 'usage_count' do
    it 'defaults to 0' do
      expect(ApiCall.new.usage_count).to eq 0
    end
  end

  describe ApiCall, :bump! do
    before(:each) do
      @api_key = FactoryGirl.create(:api_key)
    end

    it 'returns the usage_count' do
      expect(ApiCall.bump!(@api_key)).to eq 1
    end

    it 'creates a new ApiCall record for a new reporting period' do
      expect{ApiCall.bump!(@api_key)}.to change{ ApiCall.all.count }.by 1
    end

    it 'bumps the count on an existing record' do
      ApiCall.bump!(@api_key)
      expect(ApiCall.bump!(@api_key)).to eq 2
    end

    it 'creates separate records for different api_keys' do
      @api_key2 = FactoryGirl.create(:api_key, id: 2)
      expect(ApiCall.bump!(@api_key)).to eq 1
      expect(ApiCall.bump!(@api_key2)).to eq 1
    end
  end

end
