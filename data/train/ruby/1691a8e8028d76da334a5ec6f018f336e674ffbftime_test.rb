require 'test_helper'

module Scrapybara
  class NumericTest < Test::Unit::TestCase

    context "When converting time to number" do

      should "calculate seconds" do
        assert_equal 1,   1.second
        assert_equal 150, 150.seconds
      end

      should "calculate minutes" do
        assert_equal 60,   1.minute
        assert_equal 5*60, 5.minutes
      end

      should "calculate hours" do
        assert_equal 3600,    1.hour
        assert_equal 10*3600, 10.hours
      end

      should "calculate days" do
        assert_equal 3600*24,    1.day
        assert_equal 10*3600*24, 10.days
      end

      should "calculate weeks" do
        assert_equal 3600*24*7,   1.week
        assert_equal 3600*24*7*3, 3.weeks
      end

    end

  end
end
