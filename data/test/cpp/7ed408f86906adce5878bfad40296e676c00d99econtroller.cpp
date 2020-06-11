#include <iostream>
#include <bits/stdc++.h>
#include "../repos/repo.h"
#include "../models/club.h"
#include "controller.h"
using namespace std;

Repo& Controller::get_repo() {
    return this->repo;
}

bool Controller::add_club(const Club T) {
    return this->get_repo().add_club(T);
}

bool Controller::remove_club(const Club T) {
    return this->get_repo().remove_club(T);
}

vector <Club> &Controller::get_clubs() {
    return this->get_repo().get_clubs();
}

void Controller::populate_from_file(string filename) {
    this->repo.populate_from_file(filename);
}

