#include <gtest/gtest.h>
#include "model/Play.hpp"

TEST (PlayTest, HasNotEnded)
{
	model::Play p(model::Denomination::NO_TRUMP);
	
	ASSERT_FALSE(p.hasEnded());
}

TEST (PlayTest, RandomPlay)
{
	model::Play p(model::Denomination::SPADES);
	
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::ACE));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::CLUBS);
	
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::THREE));
	p.receiveCard(model::Card(	model::Suit::CLUBS,	model::Rank::TEN));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::FOUR));
	

	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::ACE));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::SPADES);
	
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::SEVEN));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::TWO));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::KING));
	
	
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::TWO));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::EIGHT));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::JACK));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::DIAMONDS);
	
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::ACE));
	
	
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::THREE));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::SIX));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::DIAMONDS);
	
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::KING));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::FIVE));
	
	
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::ACE));

	ASSERT_EQ(p.getLeadingSuit(), model::Suit::HEARTS);

	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::FOUR));
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::TWO));
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::TEN));
	
	
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::SIX));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::FIVE));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::TWO));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::CLUBS);
	
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::QUEEN));
	
	
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::KING));
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::THREE));
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::QUEEN));

	ASSERT_EQ(p.getLeadingSuit(), model::Suit::HEARTS);

	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::FIVE));
	
	
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::JACK));
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::EIGHT));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::HEARTS);	
	
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::SEVEN));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::JACK));
	
	
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::SEVEN));
	
	ASSERT_EQ(p.getLeadingSuit(), model::Suit::CLUBS);
	
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::NINE));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::FIVE));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::QUEEN));
	
	
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::NINE));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::FOUR));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::THREE));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::EIGHT));
	
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::FOUR));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::QUEEN));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::TEN));
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::NINE));
	
	p.receiveCard(model::Card(	model::Suit::DIAMONDS,	model::Rank::TEN));
	p.receiveCard(model::Card(	model::Suit::HEARTS,	model::Rank::SEVEN));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::JACK));
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::SIX));
	
	p.receiveCard(model::Card(	model::Suit::SPADES, 	model::Rank::EIGHT));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::NINE));
	p.receiveCard(model::Card(	model::Suit::HEARTS, 	model::Rank::SIX));
	p.receiveCard(model::Card(	model::Suit::CLUBS, 	model::Rank::KING));

	ASSERT_TRUE(p.hasEnded());
	ASSERT_EQ(p.getTricksWon(), 5);	
}
