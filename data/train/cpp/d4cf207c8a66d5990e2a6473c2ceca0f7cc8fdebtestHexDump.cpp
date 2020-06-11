#include <epicsUnitTest.h>
#include <testMain.h>

#include <pv/hexDump.h>

using namespace epics::pvData;
using namespace epics::pvAccess;

MAIN(testHexDump)
{
    testPlan(3);
    testDiag("Tests for hexDump");

    char TO_DUMP[] = "pvAccess dump test\0\1\2\3\4\5\6\254\255\256";

    hexDump("test", (int8*)TO_DUMP, 18+9);
    testPass("Entire array");

    hexDump("only text", (int8*)TO_DUMP, 18);
    testPass("Only text");

    hexDump("22 byte test", (int8*)TO_DUMP, 22);
    testPass("22 bytes test");

    return testDone();
}
