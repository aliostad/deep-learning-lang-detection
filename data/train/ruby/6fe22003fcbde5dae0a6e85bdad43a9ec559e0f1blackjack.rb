def calculate_value(cards)
  arr = cards.map { |e| e[1]  }
  total = 0
  arr.each do |value|
      if value == 'A'
        total += 11
      elsif value.to_i == 0
        total += 10
      else
        total += value.to_i 
      end
  end
  
  #correct for aces
  arr.select{ |e| e == 'A' }.count.times do
    total -= 10 if total > 21
  end

  total
end

def deal_to(player, deck)
  player << deck.pop
end

def show_cards(player, dealer)
  "Player holds " + calculate_value(player).to_s + ", dealer shows " + calculate_value(dealer).to_s
end

puts "Welcome to Blackjack!"
  # deck setup
  suits = ["H", "D", "S", "C"]
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  deck = suits.product(cards)

game_on = true
while game_on
  # dealing the cards
  deck.shuffle!
  player_cards = []
  dealer_cards = []

  2.times do deal_to(dealer_cards, deck) end
  2.times do deal_to(player_cards, deck) end

  # gameplay
  puts "Player shows: #{player_cards}. Total value: #{calculate_value(player_cards)}" 
  puts "Dealer shows: #{dealer_cards[1]}."


  # player turn
  player_turn = true
  while player_turn
    if calculate_value(player_cards) < 21
    puts "Enter 1 to hit, 0 to hold.."
    hit_hold = gets.chomp.to_i
      if hit_hold == 1
        deal_to(player_cards, deck)
        puts "Player shows: #{player_cards}. Total value: #{calculate_value(player_cards)}"
      elsif hit_hold == 0
        puts "You hold."
        player_turn = false
      else
        puts "Please enter 1 to hit, 0 to hold.."
        hit_hold = gets.chomp.to_i
      end
    elsif calculate_value(player_cards) == 21
      puts "You hit 21."
      player_turn = false
    elsif calculate_value(player_cards) > 21
      puts "You hit #{calculate_value(player_cards)}.  You bust!"
      player_turn = false
    end
  end
  puts
  # dealer turn
  puts "Dealer flips: #{dealer_cards}. Total value: #{calculate_value(dealer_cards)}"
  sleep(2)
  dealer_turn = true
  while dealer_turn
    if calculate_value(dealer_cards) < 17
      puts "Dealer hits.."
      sleep(1)
      deal_to(dealer_cards, deck)
      puts "Dealer recieves #{dealer_cards.last}, total #{calculate_value(dealer_cards)}"
    elsif calculate_value(dealer_cards) == 21
      puts "Dealer has Blackjack."
      dealer_turn = false
    elsif calculate_value(dealer_cards) > 21
      puts "Dealer busts!"
      dealer_turn = false
    elsif calculate_value(dealer_cards) >= 17
      puts "Dealer holds at #{calculate_value(dealer_cards)}"
      dealer_turn = false
    end
  end
  puts

  # calculate winner
  if calculate_value(player_cards) == 21
    if calculate_value(dealer_cards) == 21
      puts "#{show_cards(player_cards, dealer_cards)}, push."
    elsif calculate_value(dealer_cards) < 21
      puts "#{show_cards(player_cards, dealer_cards)}, player wins!"
    elsif calculate_value(dealer_cards) > 21
      puts "#{show_cards(player_cards, dealer_cards)}, player wins!"
    end
  elsif calculate_value(player_cards) < 21
    if calculate_value(dealer_cards) == 21
      puts "#{show_cards(player_cards, dealer_cards)}, dealer wins."
    elsif calculate_value(dealer_cards) < calculate_value(player_cards)
      puts "#{show_cards(player_cards, dealer_cards)}, player wins!"
    elsif calculate_value(dealer_cards) > 21
      puts "#{show_cards(player_cards, dealer_cards)}, player wins!"
    elsif calculate_value(dealer_cards) > calculate_value(player_cards)
      puts "#{show_cards(player_cards, dealer_cards)}, dealer wins."
    elsif calculate_value(dealer_cards) == calculate_value(player_cards)
      puts "#{show_cards(player_cards, dealer_cards)}, push."
    end
  elsif calculate_value(player_cards) > 21
    if calculate_value(dealer_cards) == 21
      puts "#{show_cards(player_cards, dealer_cards)}, dealer wins."
    elsif calculate_value(dealer_cards) < 21
      puts "#{show_cards(player_cards, dealer_cards)}, dealer wins."
    elsif calculate_value(dealer_cards) > 21
      puts "#{show_cards(player_cards, dealer_cards)}, push."
    end
  end
  puts
  puts "Deal again? 1 to deal again, 0 to leave Blackjack."
  next_deal = gets.chomp.to_i
  if next_deal == 1
    deck = suits.product(cards)
  elsif next_deal == 0
    puts "Thanks for playing Blackjack!"
    game_on = false
  end
end




