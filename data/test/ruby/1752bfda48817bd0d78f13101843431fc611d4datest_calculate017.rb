require 'rspec'
require './calculate017'

describe Calculate do
  describe "total_number_letter_count" do
    it "should calculate the number of letters in a number written in words" do
      expect(Calculate.total_number_letter_count(5)).to eql 19
    end
  end

  describe "number_letter_count" do
    it "Should count the letters in a string representation of a number" do
      expect(Calculate.number_letter_count(342)).to eql 23
      expect(Calculate.number_letter_count(115)).to eql 20
    end
  end 

  describe "wordify" do
    it "should convert numbers into words" do
      Calculate.wordify(9).should eql "nine"
      Calculate.wordify(10).should eql "ten"
      Calculate.wordify(11).should eql "eleven"
      Calculate.wordify(20).should eql "twenty"
      Calculate.wordify(21).should eql "twentyone"
      Calculate.wordify(342).should eql "threehundredandfortytwo"
      Calculate.wordify(115).should eql "onehundredandfifteen"
    end
  end
end
