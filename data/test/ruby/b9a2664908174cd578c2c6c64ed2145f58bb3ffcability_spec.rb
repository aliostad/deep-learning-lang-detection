require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before do
    @user = FactoryGirl.create :user
  end

  subject { Ability.new(@user) }

  it "should be an ability object" do
    subject.should be_instance_of Ability
  end

  it "should be able to manage self" do
    subject.can?(:manage, @user).should be_true
  end

  specify "a user should not be able to manage another user" do
    subject.can?(:manage, FactoryGirl.create(:user)).should be_false
  end

  specify "a user can manage their own account" do
    subject.can?(:manage, @user.account).should be_true
  end

  specify "a user cannot manage another account" do
    user = FactoryGirl.create :user
    subject.can?(:manage, user.account).should be_false
  end

  specify "a user can manage their rides" do
    ride = FactoryGirl.create :ride, :user => @user
    subject.can?(:manage, ride).should be_true
  end
  
  specify "a user cannot manage another user's rides" do
    user = FactoryGirl.create :user
    ride = FactoryGirl.create :ride, :user => user
    subject.can?(:manage, ride).should be_false
  end

end
