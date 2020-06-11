#include "model/Trick.hpp"
#include "model/Card.hpp"
#include "model/Denomination.hpp"
#include <gtest/gtest.h>

TEST(TrickTest, OneColour)
{
	model::Trick t(model::Denomination::HEARTS);
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::TEN));
	ASSERT_FALSE(t.hasEnded());
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::TWO));
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::KING));
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::QUEEN));
	ASSERT_TRUE(t.hasEnded());
	ASSERT_EQ(2, t.getWinner());
}
TEST(TrickTest, TrumpBeat)
{
	model::Trick t(model::Denomination::SPADES);
	ASSERT_FALSE(t.hasEnded());
	t.addCard(model::Card(model::Suit::CLUBS, model::Rank::ACE));
	t.addCard(model::Card(model::Suit::CLUBS, model::Rank::KING));
	t.addCard(model::Card(model::Suit::CLUBS, model::Rank::QUEEN));
	t.addCard(model::Card(model::Suit::SPADES, model::Rank::TWO));
	ASSERT_EQ(3, t.getWinner());
	ASSERT_TRUE(t.hasEnded());
}
TEST(TrickTest, TwoTrumps)
{
	model::Trick t(model::Denomination::DIAMONDS);
	t.addCard(model::Card(model::Suit::SPADES, model::Rank::ACE));
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::TEN));
	t.addCard(model::Card(model::Suit::SPADES, model::Rank::TWO));
	ASSERT_FALSE(t.hasEnded());
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::JACK));
	ASSERT_EQ(3, t.getWinner());
	ASSERT_TRUE(t.hasEnded());
}
TEST(TrickTest, WrongColour)
{
	model::Trick t(model::Denomination::CLUBS);
	t.addCard(model::Card(model::Suit::SPADES, model::Rank::TWO));
	t.addCard(model::Card(model::Suit::HEARTS, model::Rank::SEVEN));
	ASSERT_FALSE(t.hasEnded());
	t.addCard(model::Card(model::Suit::DIAMONDS, model::Rank::NINE));
	t.addCard(model::Card(model::Suit::HEARTS, model::Rank::THREE));
	ASSERT_EQ(0, t.getWinner());
	ASSERT_TRUE(t.hasEnded());
}
TEST(TrickTest, NoTrump)
{
	model::Trick t(model::Denomination::NO_TRUMP);
	t.addCard(model::Card(model::Suit::HEARTS, model::Rank::KING));
	t.addCard(model::Card(model::Suit::CLUBS, model::Rank::ACE));
	t.addCard(model::Card(model::Suit::HEARTS, model::Rank::TWO));
	t.addCard(model::Card(model::Suit::HEARTS, model::Rank::ACE));
	ASSERT_EQ(3, t.getWinner());
	
//	ASSERT_EQ(t.getCardsView()[0], model::Card(model::Suit::HEARTS, model::Rank::KING));
}
