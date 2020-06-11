#pragma once
#include <cxxtest/TestSuite.h>
#include "helpers.h"

using namespace Helpers;

/**
 * Tests calling
 */
class VMCallingTestSuite : public CxxTest::TestSuite {
public:
	//Tests calling with int arguments
	void testCallInt() {
		TS_ASSERT_EQUALS(invokeVM("calling/arg1"), "4\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg2"), "9\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg2_2"), "7\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg3"), "12\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg4"), "14\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg5"), "20\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg6"), "27\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg7"), "35\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg7_2"), "1337\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg8"), "44\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg8_2"), "7\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg8_3"), "6\n7\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg9"), "54\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg10"), "65\n");
	}

	//Tests calling with float arguments
	void testCallFloat() {
		TS_ASSERT_EQUALS(invokeVM("calling/arg1_float"), "4\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg2_float"), "9\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg3_float"), "12\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg4_float"), "14\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg5_float"), "20\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg6_float"), "27\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg6_float_2"), "6\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg7_float"), "35\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg7_float_2"), "1337\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg8_float"), "44\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg9_float"), "54\n0\n");
	}

	//Tests calling with mixed arguments
	void testCallMix() {
		TS_ASSERT_EQUALS(invokeVM("calling/arg6_float_and_int"), "27\n0\n");
		TS_ASSERT_EQUALS(invokeVM("calling/arg6_float_and_int_2"), "27\n0\n");
	}
};