

puts "Please enter a candidate name."
    get_results = gets.chomp
puts "Please enter vote totals by precinct. When done, please type \"done\"."

calculate_votes = []
    def calculate_votes 
        results.each do |vote|
        total_votes = (total_votes + vote) / vote * 100
        
    while true
        vote = gets.chomp
            if (vote.downcase == 'done')
                exit
            else
                calculate_votes.push(vote.to_i)
            end
        end



print "{#get_results} is winning with {#calculate_votes}% of the votes."
end