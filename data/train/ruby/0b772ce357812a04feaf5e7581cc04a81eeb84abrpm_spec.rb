require_relative '../../lib/rpm'
require 'spec_helper'

class XyzOperator < BigDecimal
  def xyz(value)
    self + value + 2
  end
end

describe Rpm do
  describe "#calculate" do
    it "calculates the result of 6 3 +" do
      subject = Rpm.new([6, 3, :+])

      expect(subject.calculate).to eq 9
    end

    it "calculates the result of 6 3 + 4 -" do
      subject = Rpm.new("6 3 + 4 -")

      expect(subject.calculate).to eq 5
    end

    it "calculates the result of 6 2 /" do
      subject = Rpm.new("6 2 /")

      expect(subject.calculate).to eq 3
    end

    it "calculates the result of 4 2 * 3 -" do
      subject = Rpm.new("4 2 * 3 -")

      expect(subject.calculate).to eq 5
    end

    it "calculates the result of 2 3 4 5 - + *" do
      subject = Rpm.new("2 3 4 5 - + *")

      expect(subject.calculate).to eq 4
    end

    it "calculates the result of 5 2 / 3 *" do
      subject = Rpm.new("5 2 / 3 *")

      expect(subject.calculate).to eq 7.5
    end

    it "raises an error when expression has invalid operator" do
      subject = Rpm.new("5 2 & 3 *")

      expect { subject.calculate }.to raise_error("Operator & not valid")
    end

    context "without expression" do
      it "raises an error when expression is blank" do
        subject = Rpm.new("")

        expect { subject.calculate }.to raise_error("Expression not given")
      end

      it "raises an error when expression is nil" do
        subject = Rpm.new(nil)

        expect { subject.calculate }.to raise_error("Expression not given")
      end
    end

    context "with a custom operator class" do
      it "calculates xyz in the expression" do
        subject = Rpm.new("5 2 xyz 3 *", XyzOperator)

        expect(subject.calculate).to eq 27
      end
    end
  end
end
