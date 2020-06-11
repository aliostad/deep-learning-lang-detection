require 'spec_helper'
require 'cancan/matchers'

describe 'User abilities for' do
  
  before(:each) do
    @active_user = Fabricate(:active_user)
    @inactive_user = Fabricate(:inactive_user)
  end
  
  context 'subscribed users' do
    
    before do
      @ability = Ability.new(@active_user)
    end
    
    they "can manage their subscriptions" do
      @ability.should be_able_to :manage, @active_user.subscription
    end
    
    they "cannot manage other user's subscriptions" do
      @ability.should_not be_able_to :manage, Fabricate(:subscription)
    end
    
    they "can view plans" do
      @ability.should be_able_to :read, Plan
    end
    
    they "cannot manage plans" do
      @ability.should_not be_able_to :manage, Plan
    end
    
  end


  context 'inactive users' do
    
    before do
      @ability = Ability.new(@inactive_user)
    end
    
    they "can view plans" do
      @ability.should be_able_to :read, Plan
    end
    
    they "cannot manage plans" do
      @ability.should_not be_able_to :manage, Plan
    end
    
    they "cannot manage subscriptions" do
      @ability.should be_able_to :manage, Subscription
    end
    
  end


  context 'visitors' do
    
    before do
      @ability = Ability.new(nil)
    end
    
  end
  
  
end