require "test_helper"

module Domain
  module Commands    
    class CalculateBattingAveragesTest < Minitest::Test
      Calculation = Struct.new(:hits, :at_bats, :batting_average)
       
      def test_should_calculate_batting_average
        calculations = [Calculation.new(20,40, nil), Calculation.new(20,125, nil)]
        
        command = Domain::Commands::CalculateBattingAverages.new
        
        command.execute(calculations)
        
        assert_equal 0.5, calculations[0].batting_average
        assert_equal 0.16, calculations[1].batting_average  
      end
    end
  end
end