#include "catch.hpp"

#include <string>
#include <memory>

#include "order/robot_order_repo.hpp"

#include "rrs_error.hpp"

TEST_CASE("RobotOrderRepo Basic Save Operations") {
   RobotOrderRepo &repo = RobotOrderRepo::GetInstance();
   std::vector<std::unique_ptr<RobotOrder>> robot_orders;
   constexpr int kQuantity = 2;
   constexpr int kModelNumber = 1324;
   constexpr double kPrice = 20;

   std::unique_ptr<RobotOrder> robot_order{new RobotOrder{kModelNumber, 
       kQuantity, kPrice}};

   REQUIRE(repo.SaveRobot(std::move(robot_order)) == RrsError::NO_ERROR);
   REQUIRE(repo.GetAllRobotOrders(robot_orders) == RrsError::NO_ERROR);
   REQUIRE(robot_orders.size() == 1);
}
