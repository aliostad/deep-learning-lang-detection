#include "cpptest.h"
#include "unit_test.h"
#include "core/utilities/src/RunParams.h"
#include "ChannelLocatorStub.h"
#include "core/message/src/TA_CosUtility.h"
#include "ChannelLocatorConnectionObservers.h"

CPPTEST_CONTEXT("core.message.test.cpptest.TA_Message_CppTest/core.message.test.cpptest/generic_common/ConnectionThread.cpp");
CPPTEST_TEST_SUITE_INCLUDED_TO("core.message.test.cpptest.TA_Message_CppTest/core.message.test.cpptest/generic_common/ConnectionThread.cpp");

class TestSuite_isChannelLocatorReachable_24de00e : public CppTest_TestSuite
{
    private:

        // function parameters
        std::string m_corbaloc_url;
        TA_Base_Core::IChannelLocator_var m_channel_locator;
        std::string m_prev_agent_id;

    public:
        CPPTEST_TEST_SUITE(TestSuite_isChannelLocatorReachable_24de00e);
        CPPTEST_TEST(test_isChannelLocatorReachable_1_not_reachable);
        CPPTEST_TEST(test_isChannelLocatorReachable_2_throw_CORBA__Exception);
        CPPTEST_TEST(test_isChannelLocatorReachable_3_reachable);
        CPPTEST_TEST_SUITE_END();

        void setUp();
        void tearDown();

        void test_isChannelLocatorReachable_1_not_reachable();
        void test_isChannelLocatorReachable_2_throw_CORBA__Exception();
        void test_isChannelLocatorReachable_3_reachable();
};

CPPTEST_TEST_SUITE_REGISTRATION(TestSuite_isChannelLocatorReachable_24de00e);


void TestSuite_isChannelLocatorReachable_24de00e::setUp()
{
    FUNCTION_ENTRY( "setUp" );

    // initialize function parameters
    m_corbaloc_url = "localhost";
    m_channel_locator = TA_Base_Core::IChannelLocator::_nil();
    m_prev_agent_id = "";

    unit_test::initialize_corba();

    FUNCTION_EXIT;
}


void TestSuite_isChannelLocatorReachable_24de00e::tearDown()
{
    FUNCTION_ENTRY( "tearDown" );

    unit_test::destroy_corba();

    FUNCTION_EXIT;
}


/* CPPTEST_TEST_CASE_BEGIN test_isChannelLocatorReachable_1_not_reachable */
/* CPPTEST_TEST_CASE_CONTEXT bool TA_Base_Core::ChannelLocatorConnection::isChannelLocatorReachable(const std::string &, TA_Base_Core::IChannelLocator_ptr, const std::string &) const */
void TestSuite_isChannelLocatorReachable_24de00e::test_isChannelLocatorReachable_1_not_reachable()
{
    FUNCTION_ENTRY( "test_isChannelLocatorReachable_1_not_reachable" );

    // PREPARE PRECONDITION
    CPPTEST_ASSERT( unit_test::ChannelLocatorStub::get_instance().start_service() );

    // PREPARE OBJECT
    TA_Base_Core::ChannelLocatorConnection channel_locator_connection( TA_Base_Core::gMakeServiceAddr(unit_test::notify_host, unit_test::notify_port) );

    {
        // THE TEST
        m_channel_locator = unit_test::ChannelLocatorStub::get_instance()._this();
        m_prev_agent_id = "wrong_id";

        CPPTEST_ASSERT( false == channel_locator_connection.isChannelLocatorReachable( m_corbaloc_url, m_channel_locator, m_prev_agent_id ) );
    }

    // CLEAR UP
    channel_locator_connection.terminateAndWait();

    FUNCTION_EXIT;
}
/* CPPTEST_TEST_CASE_END test_isChannelLocatorReachable_1_not_reachable */


/* CPPTEST_TEST_CASE_BEGIN test_isChannelLocatorReachable_2_throw_CORBA__Exception */
/* CPPTEST_TEST_CASE_CONTEXT bool TA_Base_Core::ChannelLocatorConnection::isChannelLocatorReachable(const std::string &, TA_Base_Core::IChannelLocator_ptr, const std::string &) const */
void TestSuite_isChannelLocatorReachable_24de00e::test_isChannelLocatorReachable_2_throw_CORBA__Exception()
{
    FUNCTION_ENTRY( "test_isChannelLocatorReachable_2_throw_CORBA__Exception" );

    // PREPARE PRECONDITION
    CPPTEST_ASSERT( unit_test::ChannelLocatorStub::get_instance().start_service() );

    // PREPARE OBJECT
    TA_Base_Core::ChannelLocatorConnection channel_locator_connection( TA_Base_Core::gMakeServiceAddr(unit_test::notify_host, unit_test::notify_port) );

    {
        // THE TEST
        unit_test_throw_exception_when_log_guard( "CORBA::Exception", TA_Base_Core::DebugUtil::DebugError, "ChannelLocatorConnection::isChannelLocatorReachable(): %s unable to contact IChannelLocator at %s: agentID has changed" );

        m_channel_locator = unit_test::ChannelLocatorStub::get_instance()._this();
        m_prev_agent_id = "wrong_id";

        CPPTEST_ASSERT( false == channel_locator_connection.isChannelLocatorReachable( m_corbaloc_url, m_channel_locator, m_prev_agent_id ) );
    }

    // CLEAR UP
    channel_locator_connection.terminateAndWait();

    FUNCTION_EXIT;
}
/* CPPTEST_TEST_CASE_END test_isChannelLocatorReachable_2_throw_CORBA__Exception */


/* CPPTEST_TEST_CASE_BEGIN test_isChannelLocatorReachable_3_reachable */
/* CPPTEST_TEST_CASE_CONTEXT bool TA_Base_Core::ChannelLocatorConnection::isChannelLocatorReachable(const std::string &, TA_Base_Core::IChannelLocator_ptr, const std::string &) const */
void TestSuite_isChannelLocatorReachable_24de00e::test_isChannelLocatorReachable_3_reachable()
{
    FUNCTION_ENTRY( "test_isChannelLocatorReachable_3_reachable" );

    // PREPARE PRECONDITION
    CPPTEST_ASSERT( unit_test::ChannelLocatorStub::get_instance().start_service() );

    // PREPARE OBJECT
    TA_Base_Core::ChannelLocatorConnection channel_locator_connection( TA_Base_Core::gMakeServiceAddr(unit_test::notify_host, unit_test::notify_port) );

    {
        // THE TEST
        m_channel_locator = unit_test::ChannelLocatorStub::get_instance()._this();
        m_prev_agent_id = m_channel_locator->getID();

        CPPTEST_ASSERT( true == channel_locator_connection.isChannelLocatorReachable( m_corbaloc_url, m_channel_locator, m_prev_agent_id ) );
    }

    // CLEAR UP
    channel_locator_connection.terminateAndWait();

    FUNCTION_EXIT;
}
/* CPPTEST_TEST_CASE_END test_isChannelLocatorReachable_3_reachable */
