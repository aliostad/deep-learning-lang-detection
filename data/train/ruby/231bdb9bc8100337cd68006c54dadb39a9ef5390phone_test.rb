#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'phone'
require "rubygems"
require "bundler/setup"

class HappyTestPhoneCombinator < MiniTest::Unit::TestCase
  def setup
    @combinator = PhoneCombinator.new
  end
  
  def test_default_len_zero
    assert_equal [], @combinator.calculate("0")
  end

  def test_special_numbers
    assert_equal @combinator.calculate("23"), @combinator.calculate("123")
    assert_equal @combinator.calculate("23"), @combinator.calculate("023")   
  end  

  def test_simple_case
    assert_equal ['ad', 'ae', 'af', 'bd', 'be', 'bf', 'cd', 'ce', 'cf'], @combinator.calculate("23")
  end

end

class SadTestPhoneCombinator < MiniTest::Unit::TestCase
  def setup
    @combinator = PhoneCombinator.new
  end

  def test_default_len_zero
    assert_equal [], @combinator.calculate()
  end

  def test_special_numbers_alone
    assert_equal [], @combinator.calculate("1")
    assert_equal [], @combinator.calculate("11")
    assert_equal [], @combinator.calculate("0")
    assert_equal [], @combinator.calculate("00")
    assert_equal [], @combinator.calculate("10")
    assert_equal [], @combinator.calculate("1010")
  end

  def test_chars_in_num
    assert_equal [], @combinator.calculate('a')
    assert_equal [], @combinator.calculate('a1')
    assert_equal ['a','b','c'], @combinator.calculate('2')

  end

end

