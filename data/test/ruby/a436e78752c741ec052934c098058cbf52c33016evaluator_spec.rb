# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'
require 'japanize'
describe Evaluator do

  it "must calculate single operation" do
    Evaluator.new([1, 2, :+]).evaluate.must_equal 3
  end

  it "must calculate multiple operations" do
    Evaluator.new([1, 2, :+, 3 , :*]).evaluate.must_equal 9
  end

  it "must calculate div operations" do
    Evaluator.new([6, 2, :/]).evaluate.must_equal 3
  end

  it "must calculate sub operations" do
    Evaluator.new([6, 2, :-]).evaluate.must_equal 4
  end

  it "must calculate float " do
    Evaluator.new([1.5, 2, :+]).evaluate.must_equal 3.5
  end

  it "must calculate all operands" do
    Evaluator.new([1, 2, :+, 3 , :* , 1, :-, 2, :/]).
      evaluate.must_equal ((((1+2) * 3) - 1 ) / 2)
  end
end

