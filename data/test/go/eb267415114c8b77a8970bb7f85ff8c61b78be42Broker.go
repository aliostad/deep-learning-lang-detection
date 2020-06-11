// Copyright 2017 marina.github@gmail.com All rights reserved.
// Use of this source code is governed under the GNU General Public License v3.0
// that can be found in the LICENSE file.

package splendor

import "fmt"

type Broker struct {
	board Board
	queue  map[int][]Card
}

func NewBroker(game *Splendor) *Broker {
	gems := make(map[string]int)
	for _, v := range []string{"d", "s", "e", "o", "r"} {
		gems[v] = game.setup.gems
	}
	gems["g"] = game.setup.gold

	noble := shuffle(deckNoble)[:game.setup.nobles]
	queue := map[int][]Card{
		1: shuffle(deckLevel1),
		2: shuffle(deckLevel2),
		3: shuffle(deckLevel3),
	}

	openedCards := map[int][]Card{}


	broker := &Broker{ queue:queue}
	for iLevel := 1; iLevel <= 3; iLevel++ {
		cards:=[]Card{}
		for j := 0; j < game.setup.numCards; j++ {
			broker.openNextCard(iLevel, &cards)
		}
		openedCards[iLevel] = cards;
	}

	broker.board = Board{gems, openedCards, noble}

	return broker
}

func (broker *Broker) openNextCard(level int, cards *[]Card) {
	if len(broker.queue[level]) > 0 {
		//Pop from a queue:
		card := broker.queue[level][0]
		broker.queue[level] = broker.queue[level][1:]
		*cards = append(*cards, card)
	}
}

func (broker *Broker) getOpenedCards() []Card {
	cards := make([]Card, 0, len(broker.board.cards))

	for  key := range broker.board.cards {
		for _, c :=range broker.board.cards[key]{
			cards = append(cards, c)
		}
	}
	return cards
}

func (broker *Broker) getGems() Gems {
	return broker.board.gems
}

func (broker *Broker) ToString() {
	fmt.Print("\nGems:\n\t", broker.board.gems)
	fmt.Print("\nCards:")
	for  key := range broker.board.cards {
		fmt.Print("\nLevel:", key)
		for _, c :=range broker.board.cards[key]{
			fmt.Print("\n\t", c)
		}
	}
}