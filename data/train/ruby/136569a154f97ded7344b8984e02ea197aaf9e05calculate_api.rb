module CalculateApi
  def self.calculate(param)
    begin
      output = {}
      output[:partial] = "commands/calculate/calculate_result"
      output[:data] = "Could not calculate #{param[:attr]}"
        
      parser = ExpressionParser::Parser.new
      
      calculate_result = parser.parse(param[:attr])
        
      output[:data] = "#{param[:attr]} = #{calculate_result}"
      
      return output
    rescue RuntimeError
      output[:data] =  "Could not calculate #{param[:attr]}"
      return output
    end
  end
end