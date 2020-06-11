/*
 * gameController.cpp
 *
 *  Created on: Nov 29, 2013
 *      Author: robin
 */

#include "gameController.h"

namespace game {

GameController::GameController(std::shared_ptr<ModelPtr> model) : model_(model), time_(0){
}

GameController::~GameController() {
	// TODO Auto-generated destructor stub
}

void GameController::startCycle() {
	time_ = model_->model->getTime();
}

void GameController::pause() {
	model_->model->pauseTime_+= model_->model->getTime();
	model_->model->paused_ = true;
}

void GameController::go() {
	model_->model->clock_.restart();
	model_->model->paused_ = false;
}


void GameController::fireGun() {
	if (time_ - model_->model->gunLastFired_ >= model_->model->gunFireSpeed_) {
		model_->model->bullets_.push_back(model_->model->gun_->fire());
		model_->model->gunLastFired_ = time_;
	}
}

void GameController::moveAndFire() {

	// fire aliens

	for (auto a : model_->model->aliens_) {
		bool fire = true;
		// let only the aliens up front fire
		for (auto b : model_->model->aliens_) {
			if ((b->getPosition().first == a->getPosition().first) && (b->getPosition().second > a->getPosition().second)) {
				fire = false;
				}
			}
		if (fire) {
			std::shared_ptr<objects::Bullet> temp(a->fire(time_));
			if (temp != nullptr) {
				model_->model->bullets_.push_back(temp);
			}
		}
	}


	// move all objects;
	for (auto b : model_->model->bullets_) {
		b->move(time_, model_->model->bulletUpdateDelay_);
	}

	for (auto c : model_->model->aliens_) {
		c->move(time_);
	}

}

void GameController::moveGun(objects::MoveDirection dir) {
	std::cout << "moving gun" << std::endl;
	if (dir != objects::right && dir != objects::left) {
		throw(Exception("A GUN CAN ONLY MOVE LEFT OR RIGHT"));
	}
	else {
		model_->model->gun_->setMove(dir);
		model_->model->gun_->move();
	}
}

void GameController::check() {
	checkBoundaries();
	checkCollision();
	// check nr of aliens left:
	if (model_->model->aliens_.size() == 0) {
		std::cout << "level " << model_->model->level_ << std::endl;
		if (model_->model->level_ == model_->model->nrLevels_ ){
			model_->model->win_ = true;
		}
		else {
			unsigned int score = model_->model->score_;
			model_->model = GameFactory::createGameModel("../informationFiles/level"+utility::toString(model_->model->level_+1));
			model_->model->score_ = score;
		}
	}
}

void GameController::restart() {
	model_->model = GameFactory::createGameModel("../informationFiles/level1");
}

void GameController::checkCollision() {
	// check for bullets hitting bunkers
	for (unsigned int i = 0; i< model_->model->bullets_.size(); i++) {
		for (unsigned int j = 0; j < model_->model->bunkers_.size(); j++) {
			bool hit = utility::intersects(model_->model->bullets_.at(i), model_->model->bunkers_.at(j));
			if (hit) {
				model_->model->bullets_.erase(model_->model->bullets_.begin()+i);
				i--;
				model_->model->bunkers_.at(j)->hit();
				if (!model_->model->bunkers_.at(j)->alive()) {	// check for destroyed bunkers
					model_->model->bunkers_.erase(model_->model->bunkers_.begin()+j);
					j--;
				}
				break;
			}
		}
	}

	// check for bullets hitting aliens		not those fired by aliens
	for (unsigned int i = 0; i< model_->model->bullets_.size(); i++) {
		for (unsigned int j = 0; j < model_->model->aliens_.size(); j++) {
			if (model_->model->bullets_.at(i)->getDirection() == objects::down) {
				break;
			}
			bool hit = utility::intersects(model_->model->bullets_.at(i), model_->model->aliens_.at(j));
			if (hit) {
				model_->model->score_ += model_->model->aliens_.at(j)->getScore();
				std::cout << "Score = " << model_->model->score_ << std::endl;
				model_->model->bullets_.erase(model_->model->bullets_.begin()+i);
				i--;
				model_->model->aliens_.erase(model_->model->aliens_.begin()+j);
				j--;
				break;
			}
		}
	}

	// check for bullets hitting gun 	not those fired by gun
	for (unsigned int i = 0; i< model_->model->bullets_.size(); i++) {
		if (model_->model->bullets_.at(i)->getDirection() == objects::up) {
			continue;
		}
		bool hit = utility::intersects(model_->model->bullets_.at(i), model_->model->gun_);
		if (hit) {
			std::cout << "gun hit" << std::endl;
			model_->model->gun_->liveDecr();
			model_->model->bullets_.erase(model_->model->bullets_.begin()+i);
			i--;
			model_->model->dead_ = true;
			if (model_->model->gun_->getLives() <= 0) {
				model_->model->lose_ = true;
			}
		}
	}
	// check for aliens hitting gun
	for (unsigned int i = 0; i< model_->model->aliens_.size(); i++) {

		bool hit = utility::intersects(model_->model->aliens_.at(i), model_->model->gun_);
		if (hit) {
			std::cout << "alien hit gun" << std::endl;
			std::cout << " ALien position : " << model_->model->aliens_.at(i)->getPosition().first << " , " << model_->model->aliens_.at(i)->getPosition().second << std::endl;;
			std::cout << " gun position : " << model_->model->gun_->getPosition().first << " , " << model_->model->gun_->getPosition().second << std::endl;;

			model_->model->lose_ = true;
			//gun->liveDecr();
			model_->model->aliens_.erase(model_->model->aliens_.begin()+i);
			break;
		}
	}
	// check for aliens hitting bunkers:
	for (unsigned int i = 0; i< model_->model->aliens_.size(); i++) {
		for (unsigned int j = 0; j < model_->model->bunkers_.size(); j++) {
			bool hit = utility::intersects(model_->model->aliens_.at(i), model_->model->bunkers_.at(j));
			if (hit) {
				model_->model->aliens_.erase(model_->model->aliens_.begin()+i);
				i--;
				model_->model->bunkers_.erase(model_->model->bunkers_.begin()+j);
				j--;
				break;
			}
		}
	}

}

void GameController::checkBoundaries () {
	// check for gun in screen

	if ((model_->model->gun_->getPosition().first <= model_->model->gun_->getSpeed()) ) {
		model_->model->gun_->setPosition(objects::Position(model_->model->gun_->getSpeed(),model_->model->gun_->getPosition().second));
	}
	else if (model_->model->gun_->getPosition().first > model_->model->width_ - model_->model->gun_->getSizeX()) {
		model_->model->gun_->setPosition(objects::Position(model_->model->width_ - model_->model->gun_->getSizeX(), model_->model->gun_->getPosition().second));
	}

	// check for bullets out of screen
	for (unsigned int i = 0; i < model_->model->bullets_.size(); i++)
	{
		if ((model_->model->bullets_.at(i)->getPosition().first < 0) || (model_->model->bullets_.at(i)->getPosition().first > model_->model->width_)) {
			model_->model->bullets_.erase(model_->model->bullets_.begin()+i);
			i--;
		}
		else if ((model_->model->bullets_.at(i)->getPosition().second < 0) || (model_->model->bullets_.at(i)->getPosition().second > model_->model->height_)) {
			model_->model->bullets_.erase(model_->model->bullets_.begin()+i);
			i--;
		}
		else {
			// nothing wrong
			continue;
		}
	}
	// check for aliens out of screen
	for (unsigned int i = 0; i < model_->model->aliens_.size(); i++)
	{
		if ((model_->model->aliens_.at(i)->getPosition().second < 0) || (model_->model->aliens_.at(i)->getPosition().second > model_->model->height_)) {
			model_->model->aliens_.erase(model_->model->aliens_.begin()+i);
			i--;
		}
		else if ((model_->model->aliens_.at(i)->getPosition().first < 0) || (model_->model->aliens_.at(i)->getPosition().first > model_->model->width_)) {
			model_->model->aliens_.erase(model_->model->aliens_.begin()+i);
			i--;
		}
		else {
			// nothing wrong
			continue;
		}
	}
}


} /* namespace game */
