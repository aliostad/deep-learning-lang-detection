require 'date'

module Cal
    class Day
        attr_accessor :start, :finish
        attr_reader :date, :minutes, :hours

        def start=(time)
            @start = time
            @date = @start.to_date
        end

        def finish=(time)
            @finish =time
            calculate_minutes
            calculate_hours
        end

        private

            def calculate_minutes
                unless @start.nil? 
                    @minutes = (@finish - @start)/60
                else
                    @minutes = 0
                end
            end

            def calculate_hours
                @hours = @minutes/60
            end


    end
end
