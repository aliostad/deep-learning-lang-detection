#include "gtest/gtest.h"
#include "BasicTreeFixture.h"

#include "TreeModel.h"
#include "Event.h"


typedef BasicTreeFixture TreeModelTest;


TEST_F(TreeModelTest, Construction)
{
    TreeModel model(tree);

    EXPECT_EQ(tree, model.tree());
    EXPECT_EQ(0, model.events().size());
}


TEST_F(TreeModelTest, AddEvent)
{
    TreeModel model(tree);
    model.events().push_back(Event(node4, 2.5));

    Event event = model.events()[0];

    EXPECT_EQ(node4, event.node());
    EXPECT_EQ(2.5, event.absoluteTime());
}


TEST_F(TreeModelTest, CopyConstruction)
{
    TreeModel model(tree);
    model.events().push_back(Event(node4, 2.5));

    TreeModel modelCopy(model);

    EXPECT_EQ(model.tree(), modelCopy.tree());
    EXPECT_EQ(model.events().size(), modelCopy.events().size());
}
