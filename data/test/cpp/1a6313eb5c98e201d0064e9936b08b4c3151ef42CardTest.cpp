#include <gtest/gtest.h>
#include "model/Card.hpp"

TEST(CardTest, RankEnum)
{
	ASSERT_TRUE(model::Rank::TWO < model::Rank::THREE);
	ASSERT_TRUE(model::Rank::THREE < model::Rank::FOUR);
	ASSERT_TRUE(model::Rank::FOUR < model::Rank::FIVE);
	ASSERT_TRUE(model::Rank::FIVE < model::Rank::SIX);
	ASSERT_TRUE(model::Rank::SIX < model::Rank::SEVEN);
	ASSERT_TRUE(model::Rank::SEVEN < model::Rank::EIGHT);
	ASSERT_TRUE(model::Rank::EIGHT < model::Rank::NINE);
	ASSERT_TRUE(model::Rank::NINE < model::Rank::TEN);
	ASSERT_TRUE(model::Rank::TEN < model::Rank::JACK);
	ASSERT_TRUE(model::Rank::JACK < model::Rank::QUEEN);
	ASSERT_TRUE(model::Rank::QUEEN < model::Rank::KING);
	ASSERT_TRUE(model::Rank::KING < model::Rank::ACE);
}
