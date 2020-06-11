#pragma once
#include <benchmark.h>

#include <gtest/gtest.h>

int last_count = 0;
class Given_a_sample_benchmark_method : public testing::Test {
protected:
	static void sample_method(B * b) {
		printf("sample called: %d", b_count(b));
		last_count = b_count(b);
	}
};

TEST_F(Given_a_sample_benchmark_method, _when_BENCH_is_called) {
	BENCH(100, "sample method", &sample_method)
	EXPECT_EQ(100, last_count) << "then it should have called the sample method";
}

TEST_F(Given_a_sample_benchmark_method, _when_BENCH_is_called_twice) {
	BENCH(200, "sample method", &sample_method)
	EXPECT_EQ(200, last_count) << "then it should have called the sample method";
	BENCH(300, "sample method", &sample_method)
	EXPECT_EQ(300, last_count) << "then it should have called the sample method";
}