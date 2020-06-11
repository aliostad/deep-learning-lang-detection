/** ModelTest.h:
 * Unit tests for the Model class.
 */

#ifndef MODELTEST_H_
#define MODELTEST_H_

#include <cxxtest/TestSuite.h>
#include "Scheduler.h"
#include "Model.h"
#include "Refrigerator.h"

class ModelTest : public CxxTest::TestSuite {
public:

	/** test_model_constructor:
	 * Tests that Model objects are created correctly.
	 * Tests that initial energy and power are 0.
     */
	void test_model_constructor() {
		Model model;
		TS_ASSERT_EQUALS(model.getEnergy(), 0);
		TS_ASSERT_EQUALS(model.getPower(), 0);
		TS_ASSERT_EQUALS(model.getStateChanged(), model.stateChanged_);
	}

	/** test_model_name:
	 * Tests that the getName() and setName() methods work.
     */
	void test_model_name() {
		Model model;
		std::string name = "someModel";
		model.setName(name);
		TS_ASSERT_EQUALS(model.getName(), name);
	}

	/** test_model_tick:
	 * Tests that the tick() method works.
     */
	void test_model_tick() {
		Scheduler sched;
		Model model;
		model.tick();
		model.activate("");
	}

	/** test_model_setScheduler:
	 * Tests that the Scheduler for Models is set correctly.
     */
	void test_model_setScheduler() {
		Scheduler sched;
		Model model;
		model.setScheduler(&sched);
		// Check that scheduler has been correctly set for model.
		TS_ASSERT(model.getScheduler() == &sched);
	}

	/** test_model_log:
	 * Tests that logging is done correctly.
     */
	void test_model_log() {
		Model model;
		model.logOn();
		model.logOff();
		model.logPower();
	}

	/** test_model_configure:
	 *  Tests that configuring the Dishwasher from a property table works correctly.
	 */
	void test_model_configure() {
		Model model;
		PropertyTable *props = new PropertyTable;
		props->insert(make_pair("name", "ModelName"));
		model.configure(props);
	}

};

#endif /*MODELTEST_H_*/
