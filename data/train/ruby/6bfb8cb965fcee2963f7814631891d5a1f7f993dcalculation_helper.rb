# coding: UTF-8

module CalculationHelper

  def self.calculate_owners_value(attr = :revenue, balance_reference_date = $balance_reference_date, share_reference_date = $share_reference_date)
    #Owner.each{ |o| o.calculate_sum_percentages_squares; o.save! }
    #Share.each{ |s| s.calculate_relative_participation; s.save! }
    Owner.set({}, "own_#{attr}" => nil)
    Owner.set({}, "indirect_#{attr}" => nil)
    Owner.set({}, "total_#{attr}" => nil)
    Owner.each do |o|
      o.calculate_values attr, balance_reference_date, share_reference_date
    end
  end

end
