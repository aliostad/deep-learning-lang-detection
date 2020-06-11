require 'spec_helper'

describe Chunk do
  before :all do
    @initial_request = {
      initial: {
        name: "xf-amcs6.dmg", 
        size: "66945"}
      }
  end
  
  [:redis_clean, 
    :redis_incr, 
    :redis_action, 
    :redis_find,
    :redis_cur,
    :redis_key_meta,
    :redis_key
  ].each do |method|
    it "has the following method: #{method}" do
      expect(Chunk.new(@initial_request, FactoryGirl.build(:user))).to respond_to method
    end
  end
  
  describe "Redis stuff" do
    before(:each) do
      @chunk = Chunk.new(@initial_request)
      @chunk.redis_find
    end
    after(:each) do
      @chunk.redis_clean
    end
    it "finds a new redis namespace" do
      expect(@chunk.redis_find).to match(/^0$/)
    end
    it "has some sort of action for me" do
      expect(@chunk.redis_action).to match("chunk")
    end
  end
  
  describe "File writing" do
    before(:each) do
      #@chunk = Chunk.new({})
    end
  end
  
end