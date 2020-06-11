require 'spec_helper'
require 'cancan/matchers'

describe User do
  
  context "If it's an administrator" do
    
    before(:each) do
      @admin = Ability.new ( Factory.create(:administrator) )
    end
  
    it "should be able to manage roles" do
      @admin.should be_able_to(:manage, Role.new)
    end
    
    it "should be able to manage users" do
      @admin.should be_able_to(:manage, User.new)
    end
    
    it "should be able to manage events" do
      @admin.should be_able_to(:manage, Event.new)
    end
    
     it "should be able to manage trainers" do
        @admin.should be_able_to(:manage, Trainer.new)
     end
  
  end
  
  context "If it's a comercial person" do

    before(:each) do
      @comercial = Ability.new ( Factory.create(:comercial) )
    end

  
    it "shouldn't be able to manage roles" do
      @comercial.should_not be_able_to(:manage, Role.new)
    end
    
    it "shouldn't be able to manage users" do
      @comercial.should_not be_able_to(:manage, User.new)      
    end
    
    it "should be able to manage events" do
      @comercial.should be_able_to(:manage, Event.new)
    end
    
    it "should be able to manage trainers" do
      @comercial.should be_able_to(:manage, Trainer.new)
    end
  
  end

end
