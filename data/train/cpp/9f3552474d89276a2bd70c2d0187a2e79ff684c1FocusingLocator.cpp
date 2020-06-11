/*
 * FocusingLocator.cpp
 *
 * (c) 2014 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#include <FocusingLocator.h>
#include <exceptions.h>
#include <FocusingFactoryI.h>

namespace snowstar {


FocusingLocator::FocusingLocator() {
}

Ice::ObjectPtr  FocusingLocator::locate(const Ice::Current& current,
		Ice::LocalObjectPtr& /* cookie */) {
	int	id = std::stoi(current.id.name);
	return FocusingSingleton::get(id).focusingptr;
}

void	FocusingLocator::finished(const Ice::Current& /* current */,
			const Ice::ObjectPtr& /* servant */,
			const Ice::LocalObjectPtr& /* cookie */) {
}

void	FocusingLocator::deactivate(const std::string& /* category */) {
}

} // namespace snowstar
