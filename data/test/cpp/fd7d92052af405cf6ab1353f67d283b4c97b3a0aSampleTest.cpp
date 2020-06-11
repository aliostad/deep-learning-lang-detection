#include <gtest/gtest.h>

TEST(SampleSuite, SAMPLE_TEST)
{
	//Sleep( 1000 );
	int a = 3;
	EXPECT_EQ( a, 2 );
}

TEST(SampleSuite, SAMPLE_TEST2)
{
	//Sleep( 1000 );
	float a = 3.f;

	EXPECT_NEAR( a, 2.f, 0.1f );
}

TEST(SampleSuite, SAMPLE_TEST3)
{
	//Sleep( 1000 );
	int a = 3;
	EXPECT_TRUE( a==2 );
}

TEST(SampleSuite2, SAMPLE_TEST)
{
	//Sleep( 1000 );
	int a = 3;
	EXPECT_EQ( a, 2 );
}

TEST(SampleSuite2, SAMPLE_TEST2)
{
	//Sleep( 1000 );
	int a = 3;
	EXPECT_EQ( a, 2 );
}

