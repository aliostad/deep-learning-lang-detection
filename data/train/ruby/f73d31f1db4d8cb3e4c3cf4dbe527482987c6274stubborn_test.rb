require 'test_helper'

module Test; end

def reset_test_api_class
  name = "Api"
  Test.send(:remove_const, name) if Test.const_defined?(name)
  klass =  Class.new do
    def plus_one(number)
      number + 1
    end

    def plus_three(number)
      number = plus_one(number)
      number = plus_one(number)
      plus_one(number)
    end

    def self.plus_two(number)
      number + 2
    end

    def self.plus_four(number)
      number = Test::Api.plus_two(number)
      Test::Api.plus_two(number)
    end
  end
  Test.const_set(name, klass)
end

Expectations do
  expect 2 do
    reset_test_api_class
    Test::Api.new.plus_one(1)
  end

  expect "Test::Api" do
    reset_test_api_class
    api = Test::Api.new
    api = Stubborn.should_be_stubbed(api)
    api.class.name
  end

  %w[is_a? kind_of?].each do |method|
    expect true do
      reset_test_api_class
      api = Test::Api.new
      api = Stubborn.should_be_stubbed(api)
      api.send(method, Test::Api)
    end
  end

  %w[equal? eql? == ===].each do |method|
    expect true do
      reset_test_api_class
      api = Test::Api.new
      proxied_api = Stubborn.should_be_stubbed(api)
      proxied_api.send(method, api)
    end
  end

  expect true do
    reset_test_api_class
    api = Test::Api.new
    api = Stubborn.should_be_stubbed(api)
    api.respond_to?(:plus_one)
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    api = Test::Api.new
    api = Stubborn.should_be_stubbed(api)
    api.plus_one(1) 
  end

  expect 3 do
    reset_test_api_class
    api = Test::Api.new
    api = Stubborn.should_be_stubbed(api)
    api.class.plus_two(1) 
  end

  expect "You've missed adding a stub. Consider this suggestions:\ntest_api_instance.stub!(:plus_one).with(0).and_return(1)\ntest_api_instance.stub!(:plus_one).and_return(1)" do
    reset_test_api_class
    api = Test::Api.new
    api = Stubborn.should_be_stubbed(api)
    begin
      api.plus_one(0)
    rescue => e 
      e.message
    end
  end

  expect "You've missed adding a stub. Consider this suggestions:\nApi.singleton.stub!(:plus_one).with(0).and_return(1)\nApi.singleton.stub!(:plus_one).and_return(1)" do
    reset_test_api_class
    api = Test::Api.new
    api = Stubborn.should_be_stubbed(api, :label => "Api.singleton")
    begin
      api.plus_one(0)
    rescue => e 
      e.message
    end
  end

  expect "Test::Api" do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    api = Test::Api.new
    api.class.name
  end

  expect true do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    api = Test::Api.new
    api.respond_to?(:plus_one)
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    api = Test::Api.new
    api.plus_one(1) 
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    api = Test::Api.new
    api.class.plus_two(1) 
  end

  expect Stubborn::MissedStubException do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    Test::Api.plus_two(1) 
  end

  expect "You've missed adding a stub. Consider this suggestions:\ntest_api_instance.stub!(:plus_one).with(0).and_return(1)\ntest_api_instance.stub!(:plus_one).and_return(1)" do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    api = Test::Api.new
    begin
      api.plus_one(0)
    rescue => e 
      e.message
    end
  end

  expect "You've missed adding a stub. Consider this suggestions:\ntest_api_instance.stub!(:plus_three).with(1).and_return(4)\ntest_api_instance.stub!(:plus_three).and_return(4)" do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    api = Test::Api.new
    begin
      api.plus_three(1)
    rescue => e 
      e.message
    end
  end

  expect "You've missed adding a stub. Consider this suggestions:\nTest::Api.stub!(:plus_four).with(1).and_return(5)\nTest::Api.stub!(:plus_four).and_return(5)" do
    reset_test_api_class
    Stubborn.should_be_stubbed(Test::Api)
    begin
      Test::Api.plus_four(1)
    rescue => e 
      e.message
    end
  end
end


