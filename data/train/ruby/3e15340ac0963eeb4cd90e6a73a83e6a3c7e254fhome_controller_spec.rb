require 'spec_helper'

describe HomeController do
  let!(:controller) { HomeController.new }

  it "should have index" do
    expect(controller.respond_to?('index')).to be(true)
  end

  it "should have calculate" do
    expect(controller.respond_to?('calculate')).to be(true)
  end

  describe "calculate" do
    it "should return 1 pizza for 1 person" do
      controller.calculate(1)
      expect(controller.pizzas).to eq(1)
    end

    it "should return 2 pizzas for 4 people" do
      controller.calculate(4)
      expect(controller.pizzas).to eq(2)
    end

    it "should return 1 pizza for -6 people" do
      controller.calculate(-6)
      expect(controller.pizzas).to eq(1)
    end

    it "should return 7 pizzas for 22 people" do
      controller.calculate(22)
      expect(controller.pizzas).to eq(7)
    end

  end

end
