/*
 * File:   ModuleInvoke_InterruptHandler.h
 * Author: cancian
 *
 * Created on October 9, 2015, 2:51 PM
 */

#ifndef MODULEINVOKE_INTERRUPTHANDLER_H
#define	MODULEINVOKE_INTERRUPTHANDLER_H

#include "Module.h"

class ModuleInvoke_InterruptHandler : public Module {
public:
    ModuleInvoke_InterruptHandler(std::string name);
    ModuleInvoke_InterruptHandler(const ModuleInvoke_InterruptHandler& orig);
    virtual ~ModuleInvoke_InterruptHandler();
protected:
    virtual void do_run(Entity* entity);

private:

};

#endif	/* MODULEINVOKE_INTERRUPTHANDLER_H */

