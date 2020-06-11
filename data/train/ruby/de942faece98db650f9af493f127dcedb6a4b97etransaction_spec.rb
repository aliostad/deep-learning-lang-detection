require 'spec_helper'

describe Transaction do
  it {
    should belong_to(:category)
    should validate_presence_of(:category)
    should validate_presence_of(:executed_at)
    should validate_presence_of(:amount)
  }

  describe "Scopes" do
    pending "should return the incomings"
    pending "should return the expenses"
    pending "should return the transactions for a month"
    pending "should calculate average"
    pending "should calculate leftover"
    pending "should calculate leftover for transactions"
  end
end
