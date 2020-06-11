describe "ApiKey" do
	it "should create an apikey" do
		api_key = FactoryGirl.create(:api_key)
		api_key = ApiKey.find api_key.id
		api_key.should be_an_instance_of ApiKey
	end

	it "should create an api_key with an account" do
		account = FactoryGirl.create(:account)
		account.api_keys.first().should be_an_instance_of ApiKey
	end

	it "should destroy an api_key" do 
		api_key = FactoryGirl.create(:api_key)
		api_key = ApiKey.find api_key.id
		api_key.should be_an_instance_of ApiKey
		api_key_id = api_key.id
		api_key.destroy()
		ApiKey.find(api_key_id).should be_nil
	end

	it "should indicate when an api_key is expired" do
		api_key = FactoryGirl.build(:api_key_expired)
		api_key.expired?.should be_truthy
	end
end
