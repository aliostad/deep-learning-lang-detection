require_relative "stats/calculate_statistic_for_principal"
require_relative "stats/calculate_statistic_for_project"
require 'singleton'
module RedmineIssueStatistics

  class Progress
    include Singleton

    def increment
      @progress.increment
      @progress
    end

    private

    def initialize
      return if @progress
      total =  Principal.count + Project.count
      @progress = ProgressBar.create(:title => "Calculation in progress: ", :starting_at => 0, :total => total,
                                     :format => "%t: %c/%C [%b%i] %e ")
    end
  end

  class CalculateStatistic
    def calculate
      calculate_stats_for_project
      calculate_stats_for_principal
    end

    private

    def periods
      @periods ||= %w(week month year all)
    end

    def calculate_stats_for_project
      CalculateStatisticForProject.new.calculate periods
    end

    def calculate_stats_for_principal
      CalculateStatisticForPrincipal.new.calculate periods
    end
  end
end
