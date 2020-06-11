#------------------------------------------------------------------------------
#
# ReplacementCostCalculator
#
#------------------------------------------------------------------------------
class ReplacementCostCalculator < CostCalculator

  # Determines the calculated replacement cost for an asset.
  def calculate(asset)

    # The default behavior is to return the replacement cost of the asset from the schedule
    asset.policy_analyzer.get_replacement_cost

  end

  # As we are using the schedule, there is no difference using the date so we
  # simply delegate to the calculate method
  def calculate_on_date(asset,on_date=nil)
    calculate(asset)
  end

end
