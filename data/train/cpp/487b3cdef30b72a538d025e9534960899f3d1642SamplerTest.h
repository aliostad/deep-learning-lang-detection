#include "gtest/gtest.h"
#include "../base/Sampler.h"

// ------------------------------------------------------------
// Vector Operations Test
// ------------------------------------------------------------

class SamplerTest : public ::testing::Test {
};

TEST_F(SamplerTest, GenerateSampleTest) {
  Sampler s(2, 2);
  Sample x;

  EXPECT_TRUE(s.generateSample(&x));
  EXPECT_EQ(Sample(0, 0), x);

  EXPECT_TRUE(s.generateSample(&x));
  EXPECT_EQ(Sample(1, 0), x);

  EXPECT_TRUE(s.generateSample(&x));
  EXPECT_EQ(Sample(0, 1), x);

  EXPECT_TRUE(s.generateSample(&x));
  EXPECT_EQ(Sample(1, 1), x);

  EXPECT_FALSE(s.generateSample(&x));
}


