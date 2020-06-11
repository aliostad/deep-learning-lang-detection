# Start Blackjack
puts "Welcome to Blackjack!"
puts "You have the option to 'hit' or 'stay', the goal, of course, is to get 21."
puts "As the dealer, I need to keep hitting until I have 17 pts."
puts "Jacks, Queens and Kings are worth 10 pts., Aces can be either 1 or 11 pts."
puts "Your total number of points will be displayed below.  Have fun!"
puts " "
puts "--------------------------------------------------------------------------"
puts " "

def initialize_deck
  number_cards = (2..10).to_a.map! { |e| e.to_s }
  face_cards = ["Jack", "Queen", "King", "Ace"]
  base_deck = number_cards + face_cards
  full_deck = (base_deck * 4).shuffle!
end
 
# deck == a shuffled array of 52 cards  
deck = initialize_deck 

# keeps track of ea. of they players hand in an array
human_cards = []
dealer_cards = []

prompt = "=> hit or stay?"

 
def calculate_total(cards)
  total = 0
  cards.each do |card|
    if card.to_i != 0
      total += card.to_i
    elsif (card.to_i == 0) && (card != 'Ace')
      total += 10
    else
      if (total > 10) then total += 1
      else; total += 11; end
    end
  end
  return total
end

# Returns a win/lose msg
def winner?(someones_total) 
  if someones_total > 21
    puts "That's over 21, bust!" 
    exit
  elsif someones_total == 21
    puts "That is EXACTLY 21, Blackjack!"
    exit 
  end
end


human_cards << deck.pop
human_cards << deck.pop
calculate_total(human_cards)
puts "Your first two cards are #{human_cards}"
puts "Your total number of points is #{calculate_total(human_cards)}"
puts " "
winner?(calculate_total(human_cards))
dealer_cards << deck.pop
dealer_cards << deck.pop
calculate_total(dealer_cards)
puts "The dealers first two cards are #{dealer_cards}"
puts "The dealers total number of points is #{calculate_total(dealer_cards)}"
puts " "
winner?(calculate_total(dealer_cards))


# Human turn
while calculate_total(human_cards) < 21
  puts " "
  puts prompt
  choice = gets.chomp
  if choice == 'hit'
    puts " "
    human_cards << deck.pop
    puts "Your hand is #{human_cards}"
    calculate_total(human_cards)
    puts "Your total number of points is #{calculate_total(human_cards)}"
    winner?(calculate_total(human_cards))
  elsif choice == 'stay'
    puts " "
    break
  end
end

# Dealer turn
while calculate_total(dealer_cards) < 17
    dealer_cards << deck.pop
    calculate_total(dealer_cards)
    puts "The dealers hand is now #{dealer_cards}"
    puts "The dealers total number of points is #{calculate_total(dealer_cards)}"
    winner?(calculate_total(dealer_cards))
    puts " "
end
    
#  Game ends
puts "Your current number of points is #{calculate_total(human_cards)}"
puts "The dealer's current number of points is #{calculate_total(dealer_cards)}"
if  calculate_total(dealer_cards) > calculate_total(human_cards)
  puts "The house won, sorry..."
elsif calculate_total(dealer_cards) < calculate_total(human_cards)
  puts "Wow, you won!"
else
  puts "It's the rare tie!"
end

exit

