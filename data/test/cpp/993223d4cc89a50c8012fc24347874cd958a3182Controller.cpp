//
//  Controller.cpp
//  Labyrinth
//
//  Created by Mihai Costea on 30/5/13.
//  Copyright (c) 2013 Mihai Costea. All rights reserved.
//

#include "Controller.h"


Controller::Controller(Repository* repo){
    this->repo = repo;
}


void Controller::storeLabyrinth(matrix labyrinth){
    this->repo->storeLabyrinth(labyrinth);
}

matrix Controller::getLabyrinth(){
    return this->repo->getLabyrinth();
}

vector<Position> Controller::getShortestPath(){
    return domain::getShortestPath(this->repo->getLabyrinth());

}