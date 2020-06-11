#include "FoodLoad.h"

FoodLoad::FoodLoad(double maxLoad, double load)
{
	this->setMaxLoad(maxLoad);
	this->load = load;
}

FoodLoad::FoodLoad(const FoodLoad& foodLoad)
{
	this->setMaxLoad(foodLoad.getMaxLoad());
	this->loadFood(foodLoad.getLoad());
}

FoodLoad& FoodLoad::operator = (const FoodLoad& foodLoad)
{
	if (this != &foodLoad)
	{
		this->setMaxLoad(foodLoad.getMaxLoad());
		this->loadFood(foodLoad.getLoad());
	}

	return *this;
}

double FoodLoad::getMaxLoad() const
{
	return this->maxLoad;
}

double FoodLoad::getLoad() const
{
	return this->load;
}

bool FoodLoad::setMaxLoad(double maxLoad)
{
	if (maxLoad < 0 || maxLoad < this->load)
	{
		return false;
	}
	else
	{
		this->maxLoad = maxLoad;
		return true;
	}
}

double FoodLoad::loadFood(double load)
{
	if (load < 0)
	{
		return 0;
	}

	double free = this->maxLoad - this->load;

	if (free > load) {
		this->load += load;
		return load;
	}
	else
	{
		this->load = this->maxLoad;
		return free;
	}
}

double FoodLoad::unloadFood()
{
	double load = this->load;
	this->load = 0.0;
	return load;
}

double FoodLoad::unloadFood(double load)
{
	if (load < 0)
	{
		return 0;
	}

	double newLoad = this->load - load;
	
	if (newLoad < 0)
	{
		return this->unloadFood();
	}
	else
	{
		this->load = newLoad;
		return this->load;
	}
}

bool FoodLoad::isFull() const
{
	return this->getLoad() == this->getMaxLoad();
}