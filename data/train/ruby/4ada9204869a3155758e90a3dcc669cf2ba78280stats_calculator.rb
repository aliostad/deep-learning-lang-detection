module GitDiff
  class StatsCalculator
    attr_reader :collector

    def initialize(collector)
      @collector = collector
    end

    def total
      GitDiff::Stats.new(
        number_of_lines: calculate_total(:number_of_lines),
        number_of_additions: calculate_total(:number_of_additions),
        number_of_deletions: calculate_total(:number_of_deletions)
      )
    end

    private

    def calculate_total(type)
      collect_stat(type).inject(:+)
    end

    def collect_stat(type)
      stats_collection.map { |stats| stats.public_send(type) }.flatten
    end

    def stats_collection
      Array(collector.collect)
    end
  end
end