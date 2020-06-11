module ObjectDiff

  class BaseDiff

    def initialize(old, new)
      @old = old
      @new = new
      @differences = nil
    end

    def different?
      not differences.empty?
    end

    def unified_diff
      differences.collect { |difference| difference.to_s + "\n" }.join
    end

    protected

    def differences
      calculate_differences_if_first_time
      @differences
    end

    private

    def calculate_differences_if_first_time
      if @differences.nil?
        @differences = []
        calculate_differences
      end
    end

    def calculate_differences
      raise NotImplementedError
    end

  end

end
