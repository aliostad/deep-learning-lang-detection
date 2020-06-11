#include <cxxtest/TestSuite.h>
#include "helpers.h"

using namespace Helpers;

//Test branching
class VMBranchTestSuite : public CxxTest::TestSuite {
public:
	//Test with int type
	void testInt() {
		TS_ASSERT_EQUALS(invokeVM("branch/int_eq"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_eq2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/int_ne"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_ne2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/int_gt"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_gt2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/int_ge"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_ge2"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_ge3"), "1\n");

		TS_ASSERT_EQUALS(invokeVM("branch/int_lt"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_lt2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/int_le"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_le2"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("branch/int_le3"), "1\n");
	}

	//Tests with float type
	void testFloat() {
		TS_ASSERT_EQUALS(invokeVM("branch/float_eq"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_eq2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/float_ne"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_ne2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/float_gt"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_gt2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/float_ge"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_ge2"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_ge3"), "1\n");

		TS_ASSERT_EQUALS(invokeVM("branch/float_lt"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_lt2"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/float_le"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_le2"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("branch/float_le3"), "1\n");
	}

	//Test with ref type
	void testRef() {
		TS_ASSERT_EQUALS(invokeVM("branch/ref_eq1"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("branch/ref_eq2"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/ref_eq3"), "0\n");

		TS_ASSERT_EQUALS(invokeVM("branch/ref_ne1"), "1\n");
		TS_ASSERT_EQUALS(invokeVM("branch/ref_ne2"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("branch/ref_ne3"), "1\n");
	}
};