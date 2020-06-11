/*
 * FocusingLocator.h -- servant locator for focusing 
 *
 * (c) 2014 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _FocusingLocator_h
#define _FocusingLocator_h

#include <Ice/Ice.h>
#include <map>

namespace snowstar {

class FocusingLocator : public Ice::ServantLocator {
public:
	FocusingLocator();

	virtual	Ice::ObjectPtr  locate(const Ice::Current& current,
			Ice::LocalObjectPtr& cookie);

	virtual void	finished(const Ice::Current& current,
				const Ice::ObjectPtr& servant,
				const Ice::LocalObjectPtr& cookie);

	virtual void	deactivate(const std::string& category);
};

} // namespace snowstar

#endif /* _FocusingLocator_h */
