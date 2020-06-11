def calculate arr
sum = 0
ace = 0
arr.each {
	|a| if a > 10
			sum+=10
		elsif a == 1
			sum += 1
			ace = 0
		else
			sum+=a
		end
}

if ace = 1 && sum + 10 <= 21
	sum = sum + 10
end
sum
end
puts 'Welcome to Monaco Royal Casino. What is your name?'
name = gets.chomp
deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ,13]
deck = deck * 16 #with 4 decks
deck = deck.shuffle
while true
hand = []
dealer = []
card = deck.pop
hand.push(card)
deck.unshift(card)
card = deck.pop
hand.push(card)
deck.unshift(card)
card = deck.pop
dealer.push(card)
deck.unshift(card)
card = deck.pop
dealer.push(card)
deck.unshift(card)


puts name + ', your hand is ' + hand.to_s
puts 'Your score is ' + calculate(hand).to_s
puts 'Dealer hand is ' + dealer.to_s
puts 'Dealer score is ' + calculate(dealer).to_s
stay = 0
while true
puts name + ' would you like to hit or stay?'
action = gets.chomp
	if action == 'hit' 
		card = deck.pop
		puts name + ', you draw a ' + card.to_s
		hand.push(card)
		deck.unshift(card)
		puts 'Score is ' + calculate(hand).to_s
		puts hand.to_s
		if calculate(hand) > 21
			puts name + ', you bust! Gameover!'
			break
		end
		if calculate(hand) == 21
			puts '21! You win. Congratulations!'
			break
		end		
	elsif action =='stay'
		stay = 1
		finalscore = calculate(hand)
		break
	end
end
if stay == 1
	if calculate(dealer) > calculate(hand)
		puts 'Dealer is higher. Sorry, you lose.'
		break
	end
	stay = 0
	while calculate(dealer) < calculate(hand)
		card = deck.pop
		puts 'Dealer draws a ' + card.to_s
		dealer.push(card)
		deck.unshift(card)
		puts calculate(dealer)
		if calculate(dealer) > 21
			puts 'Dealer busts! You win!'
			break
		end
		if calculate(dealer) > calculate(hand)
			puts 'Dealer is higher. Sorry, you lose.'
			break
		end
	end
end
puts 'Play again?'
play_again = gets.chomp
	if play_again == 'yes'
		puts 'Resetting hands'
	elsif play_again == 'no'
		puts 'Good bye!'
		break
	end	
end






