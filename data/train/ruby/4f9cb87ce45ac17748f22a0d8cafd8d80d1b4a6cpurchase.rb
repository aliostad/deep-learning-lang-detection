require 'ostruct'
module Wineshop
  class Purchase
    attr_reader :item

    NullItem = OpenStruct.new(:calculate_amount => 0)
    def initialize(attr = {})
      @item = attr.fetch(:item) { NullItem }
      @added_to_bill = attr.fetch(:added_to_bill) { false }
    end

    def determine_amount
      @item.calculate_amount
    end

    def calculate_balance
      balance = 0
      unless @added_to_bill
        @added_to_bill = true
        balance = determine_amount
      end
      balance
    end
  end
end
