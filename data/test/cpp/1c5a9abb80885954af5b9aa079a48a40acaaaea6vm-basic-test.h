#include <cxxtest/TestSuite.h>
#include "helpers.h"

using namespace Helpers;

/**
 * Tests some basic programs
 */
class VMBasicTestSuite : public CxxTest::TestSuite {
public:
	void testBasic() {
        TS_ASSERT_EQUALS(invokeVM("basic/program1"), "100\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program2"), "3\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program3"), "15\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program4"), "21\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program5"), "4\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program6"), "15\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program7"), "5\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program8"), "10\n9\n8\n7\n6\n5\n4\n3\n2\n1\n0\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program9"), "5\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program10"), "0\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program11"), "60.48\n0\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program12"), "0\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program13"), "4711\n13.37\n1\n0\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program14"), "2\n");
        TS_ASSERT_EQUALS(invokeVM("basic/program15"), "-2\n");

        TS_ASSERT_EQUALS(invokeVM("basic/recursion1"), "21\n");
		TS_ASSERT_EQUALS(invokeVM("basic/duplicate1"), "10\n");
    }

	void testStack() {
		TS_ASSERT_EQUALS(invokeVM("stack/call_preserve_stack"), "17\n");
		TS_ASSERT_EQUALS(invokeVM("stack/float_alignment"), "13\n13\n13\n0\n");
		TS_ASSERT_EQUALS(invokeVM("stack/largestackframe1"), "55\n");
		TS_ASSERT_EQUALS(invokeVM("stack/largestackframe2"), "0\n");
		TS_ASSERT_EQUALS(invokeVM("stack/largestackframe3"), "0\n");
	}

    void testLazy() {
        TS_ASSERT_EQUALS(invokeVM("lazy/onlymain", "--no-rtlib -lc 1"), "1337\n");
        TS_ASSERT_EQUALS(invokeVM("lazy/with_invalid", "--no-rtlib -lc 1"), "1337\n");
        TS_ASSERT_EQUALS(invokeVM("lazy/mainwithcall", "--no-rtlib -lc 1"), "15\n");
        TS_ASSERT_EQUALS(invokeVM("lazy/mainwith2calls", "--no-rtlib -lc 1"), "25\n");
        TS_ASSERT_EQUALS(invokeVM("lazy/callchainwithoutpatching", "--no-rtlib -lc 1"), "25\n");
        TS_ASSERT_EQUALS(invokeVM("lazy/loop", "--no-rtlib -lc 1"), "0\n");
    }

	void testBool() {
		TS_ASSERT_EQUALS(invokeVM("bool/and1"), "false\n0\n");
		TS_ASSERT_EQUALS(invokeVM("bool/and2"), "true\n0\n");
		TS_ASSERT_EQUALS(invokeVM("bool/or1"), "true\n0\n");
		TS_ASSERT_EQUALS(invokeVM("bool/or2"), "false\n0\n");
		TS_ASSERT_EQUALS(invokeVM("bool/not"), "false\n0\n");
	}
};
