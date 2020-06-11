#include "cpptest.h"
#include "unit_test.h"
#include "core/message/src/TA_CosUtility.h"

CPPTEST_CONTEXT("core.message.test.cpptest.TA_Message_CppTest/core.message.test.cpptest/generic_common/ConnectionThread.cpp");
CPPTEST_TEST_SUITE_INCLUDED_TO("core.message.test.cpptest.TA_Message_CppTest/core.message.test.cpptest/generic_common/ConnectionThread.cpp");

class TestSuite_x7eChannelLocatorConnection_b993fb4a : public CppTest_TestSuite
{
    public:
        CPPTEST_TEST_SUITE(TestSuite_x7eChannelLocatorConnection_b993fb4a);
        CPPTEST_TEST(test_x7eChannelLocatorConnection_1);
        CPPTEST_TEST_SUITE_END();

        void setUp();
        void tearDown();

        void test_x7eChannelLocatorConnection_1();
};

CPPTEST_TEST_SUITE_REGISTRATION(TestSuite_x7eChannelLocatorConnection_b993fb4a);


void TestSuite_x7eChannelLocatorConnection_b993fb4a::setUp()
{
    FUNCTION_ENTRY( "setUp" );
    FUNCTION_EXIT;
}


void TestSuite_x7eChannelLocatorConnection_b993fb4a::tearDown()
{
    FUNCTION_ENTRY( "tearDown" );
    FUNCTION_EXIT;
}


/* CPPTEST_TEST_CASE_BEGIN test_x7eChannelLocatorConnection_1 */
/* CPPTEST_TEST_CASE_CONTEXT virtual TA_Base_Core::ChannelLocatorConnection::~ChannelLocatorConnection(void) */
void TestSuite_x7eChannelLocatorConnection_b993fb4a::test_x7eChannelLocatorConnection_1()
{
    FUNCTION_ENTRY( "test_x7eChannelLocatorConnection_1" );

    // PREPARE OBJECT
    TA_Base_Core::ChannelLocatorConnection* channel_locator_connection = new TA_Base_Core::ChannelLocatorConnection(TA_Base_Core::gMakeServiceAddr(unit_test::notify_host, unit_test::notify_port));

    channel_locator_connection->start();
    TA_Base_Core::Thread::sleep( 150 );

    unit_test::channel_observer_type channel_observer( "test_channel", 1 );
    channel_locator_connection->attach( &channel_observer );
    channel_locator_connection->terminateAndWait();

    try
    {
        // THE TEST
        delete channel_locator_connection;

        CPPTEST_ASSERT( false );
    }
    catch ( ... )
    {
    }

    // CLEAR UP

    FUNCTION_EXIT;
}
/* CPPTEST_TEST_CASE_END test_x7eChannelLocatorConnection_1 */
