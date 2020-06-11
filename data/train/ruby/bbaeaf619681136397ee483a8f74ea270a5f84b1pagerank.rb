DAMPENER = 0.85

class PageRankCalculator
    attr_reader :programmers

    def initialize programmers
        @programmers = programmers
        @seen = []
    end

    def calculate_pagerank 
        5.times do
            @programmers.programmers.each_entry do |programmer|
                calculate_pagerank_for programmer
            end
        end
    end

    def calculate_pagerank_for programmer
        sum = 0

        @programmers.find_those_who_recommend(programmer).each_entry do |recommender|
            sum += recommender.kudos / recommender.recommendations.length
        end

        programmer.kudos = (1 - DAMPENER) + (DAMPENER * sum)
    end
end

