#include "modeltest.h"
#include "../model/model.h"
#include "../model/agent.h"

void ModelTest::initTestCase()
{
}

void ModelTest::addRemoveTest()
{
    Model model;
    Agent *humanAgent = new Agent(human);
    Agent *hunterAgent = new Agent(hunter);

    model.addAgent(humanAgent);
    model.addAgent(hunterAgent);

    QCOMPARE(model.getAgents().size(), 2);

    model.removeAgent(hunterAgent);
    model.removeAgent(humanAgent);

    QCOMPARE(model.getAgents().size(), 0);
}

void ModelTest::cleanupTestCase()
{
}
