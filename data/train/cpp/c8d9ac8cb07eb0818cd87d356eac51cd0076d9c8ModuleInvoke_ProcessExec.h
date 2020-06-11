/*
 * File:   ModuleInvoke_ProcessExec.h
 * Author: cancian
 *
 * Created on October 9, 2015, 7:44 PM
 */

#ifndef MODULEINVOKE_PROCESSEXEC_H
#define	MODULEINVOKE_PROCESSEXEC_H

#include "Module.h"

class ModuleInvoke_ProcessExec : public Module {
public:
    ModuleInvoke_ProcessExec(std::string name);
    ModuleInvoke_ProcessExec(const ModuleInvoke_ProcessExec& orig);
    virtual ~ModuleInvoke_ProcessExec();
protected:
    virtual void do_run(Entity* entity);

private:

};

#endif	/* MODULEINVOKE_PROCESSEXEC_H */

