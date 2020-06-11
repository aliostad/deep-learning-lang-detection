module LazyAttributes
  module Relation
    def self.included(mod)
      mod.class_eval do
        alias_method :original_calculate, :calculate
        alias_method :calculate, :calculate_without_select_values
      end
    end

    def calculate_without_select_values(operation, column_name, options = {})
      original_select_values, self.select_values = self.select_values, []
      original_calculate(operation, column_name, options)
    ensure
      self.select_values = original_select_values
    end
  end
end
