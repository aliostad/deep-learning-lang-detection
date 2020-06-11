require File.join(File.dirname(__FILE__), 'calculation_details')

class CalculateParameterParser

  def self.parse(calculate_param)
    calculation_details = []

    if calculate_param != nil && calculate_param != ""
      calculate_param_tokens = calculate_param.split(",")
      calculate_param_tokens.each do |token|
        calculation_details << build_calculation_detail_from(token)
      end
    end

    return calculation_details
  end

  private

  def self.build_calculation_detail_from(calculate_param)
    calculate_detail_tokens = calculate_param.split(/\bas\b/i)
    raise "No alias found for equation: #{calculate_param}" if calculate_detail_tokens.size == 1

    new_column_name = calculate_detail_tokens.last.delete(%q/'"/).strip
    formula = calculate_detail_tokens.first.delete(%q/'"/).strip

    return CalculationDetails.new(new_column_name, formula)
  end

end