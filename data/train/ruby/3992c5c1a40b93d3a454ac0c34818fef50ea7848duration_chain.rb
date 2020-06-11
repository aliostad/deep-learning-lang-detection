module TimeSpanner

  class DurationChain
    extend Forwardable
    include Enumerable
    include TimeUnits

    attr_accessor :remaining, :units, :reverse
    attr_reader   :to

    def_delegator :units, :each

    def initialize(from, to, units)
      @reverse = to < from
      @from    = reverse ? to : from
      @to      = reverse ? from : to

      @remaining = @to.to_time.to_r - @from.to_time.to_r
      @units     = units.map &:new

      calculate!
    end

    private

    # Perform duration calculations for units in chain.
    def calculate!
      sort!

      each do |unit|
        calculate_unit(unit)
      end
    end

    # Units must be sorted to perform a correct calculation chain.
    def sort!
      @units = units.sort
    end

    def calculate_unit(unit)
      unit.calculate remaining, to
      unit.reverse! if reverse

      @remaining = unit.rest
    end

  end

end
