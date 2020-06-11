#include <gtest/gtest.h>

#include "model/Denomination.hpp"

TEST(Denomination, Order)
{
	ASSERT_TRUE(model::Denomination::CLUBS < model::Denomination::DIAMONDS);
	ASSERT_TRUE(model::Denomination::CLUBS < model::Denomination::HEARTS);
	ASSERT_TRUE(model::Denomination::CLUBS < model::Denomination::SPADES);
	ASSERT_TRUE(model::Denomination::CLUBS < model::Denomination::NO_TRUMP);
	ASSERT_TRUE(model::Denomination::DIAMONDS < model::Denomination::HEARTS);
	ASSERT_TRUE(model::Denomination::DIAMONDS < model::Denomination::SPADES);
	ASSERT_TRUE(model::Denomination::DIAMONDS < model::Denomination::NO_TRUMP);
	ASSERT_TRUE(model::Denomination::HEARTS < model::Denomination::SPADES);
	ASSERT_TRUE(model::Denomination::HEARTS < model::Denomination::NO_TRUMP);
	ASSERT_TRUE(model::Denomination::SPADES < model::Denomination::NO_TRUMP);
}
