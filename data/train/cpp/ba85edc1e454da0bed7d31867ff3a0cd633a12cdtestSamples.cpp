#include "gtest/gtest.h"
#include "sample.h"
#include "sampler.h"

TEST(SamplesTest, SamplerGeneratesGoodSamples) {
	Sampler sampler = Sampler(320, 240);
	Sample sample = Sample();
	sampler.getSample(sample);
	// test that first sample produced is 0,0
	EXPECT_EQ(sample.x + sample.y, 0);

	for(int i = 1; i < 321; i ++) {
		sampler.getSample(sample);
	}
	// test that sampler correctly handles rows+columns
	EXPECT_EQ(sample.x, 320);
	EXPECT_EQ(sample.y, 0);
	sampler.getSample(sample);
	EXPECT_EQ(sample.x, 0);
	EXPECT_EQ(sample.y, 1);

	while(sampler.getSample(sample)) {}
	// test that sampler ends on the right x,y
	EXPECT_EQ(sample.x, 320);
	EXPECT_EQ(sample.y, 240);
}
