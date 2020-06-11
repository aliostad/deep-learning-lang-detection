require 'spec_helper'

describe TurnProcessor do
  let(:order1) { double(:order, calculate_result: :success) }
  let(:order2) { double(:order, calculate_result: :success) }
  let(:turn) { double( :turn, orders: [order1, order2] ) }

  describe "#calculate" do
    it "tells each order to calculate a result" do
      order1.should_receive :calculate_result
      order2.should_receive :calculate_result
      TurnProcessor.new(turn).calculate
    end

    it "returns the turn" do
      TurnProcessor.new(turn).calculate.should == turn
    end
  end

  describe "#finalize" do
    it "tells each order to calculate a result" do
      order1.should_receive :calculate_result
      order2.should_receive :calculate_result
      TurnProcessor.new(turn).calculate
    end

    it "saves and returns the turn" do
      turn.should_receive :save
      TurnProcessor.new(turn).finalize.should == turn
    end
  end
end
