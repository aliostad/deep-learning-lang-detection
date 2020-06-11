#include "Controller.h"
#include "Model.h"


Controller::Controller(Model* model) : model(model) { }


void Controller::endGame() {
    model->endGame();
}

// void Controller::loadGame() {
//     model->loadGame();
// }

void Controller::ragequit(int playerNum) {
    model->ragequit(playerNum);
}

// void Controller::saveGame() {
//     model->saveGame();
// }

void Controller::startGame(int seed, std::string playerTypes[]) {
    if(model->ifGame()) {
        model->endGame();
    }
    model->startGame(seed, playerTypes);
    startRound();
}

void Controller::startRound() {
    model->startRound();
}
