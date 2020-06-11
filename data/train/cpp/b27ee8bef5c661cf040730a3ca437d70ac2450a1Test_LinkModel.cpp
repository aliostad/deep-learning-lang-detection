#include "stdafx.h"
#include "touchmind/Common.h"
#include "touchmind/selection/SelectionManager.h"
#include "touchmind/model/node/NodeModel.h"
#include "touchmind/model/link/LinkModel.h"

using namespace touchmind;
using namespace touchmind::selection;
using namespace touchmind::model;
using namespace touchmind::model::node;
using namespace touchmind::model::link;

TEST(touchmind_model_LinkModel, test001) {
  SelectionManager selectionManager;

  std::shared_ptr<NodeModel> node1(NodeModel::Create(&selectionManager));
  std::shared_ptr<NodeModel> node2(NodeModel::Create(&selectionManager));
  std::shared_ptr<LinkModel> link1(std::make_shared<LinkModel>());
  link1->SetNode(EDGE_ID_1, node1);
  link1->SetNode(EDGE_ID_2, node2);
  ASSERT_EQ(1, 1);
}

TEST(touchmind_model_LinkModel, test002) {
  ASSERT_EQ(1, 1);
}
