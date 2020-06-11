require 'spec_helper'

describe 'Syncano::Resource::ApiKey' do
  it 'should create new api key in Syncano' do
    count_before = @client.api_keys.count
    api_key = @client.api_keys.create(role_id: '2', description: 'Just testing')
    count_after = @client.api_keys.count

    (count_after - count_before).should == 1
    @client.api_keys.last[:description].should == 'Just testing'
  end

  it 'should get api keys' do
    @client.api_keys.all.each do |api_key|
      api_key.id.should_not be_nil
      api_key[:description].should_not be_nil
    end
  end

  it 'should get one project' do
    api_keys = @client.api_keys.all

    api_key = @client.api_keys.find(api_keys.last.id)
    api_key[:description].should == api_keys.last[:description]
  end

  it 'should destroy project' do
    count_before = @client.api_keys.count
    @client.api_keys.last.destroy
    count_after = @client.api_keys.count

    (count_before - count_after).should == 1
  end
end