#include "catch.hpp"

#include "GOLModel.hpp"

TEST_CASE("model is sized", "[GOLModel]") {
    GOLModel square_model(4);

    REQUIRE(square_model.number_of_rows == 4);
    REQUIRE(square_model.number_of_columns == 4);

    GOLModel rectangular_model(6, 9);

    REQUIRE(rectangular_model.number_of_rows == 6);
    REQUIRE(rectangular_model.number_of_columns == 9);
}

TEST_CASE("model initializes cells as dead", "[GOLModel]") {
    GOLModel model(5);

    for (unsigned row = 0; row < model.number_of_rows; row++) {
        for (unsigned column = 0; column < model.number_of_columns; column++) {
            REQUIRE(model.isDead(row, column));
        }
    }
}

TEST_CASE("model can flip cells", "[GOLModel]") {
    GOLModel model(1);

    model.flip(0, 0);
    REQUIRE(model.isAlive(0, 0));

    model.flip(0, 0);
    REQUIRE(model.isDead(0, 0));
}
