/*
 * File:   ModuleInvoke_ThreadExec.h
 * Author: cancian
 *
 * Created on October 11, 2015, 11:21 AM
 */

#ifndef MODULEINVOKE_THREADEXEC_H
#define	MODULEINVOKE_THREADEXEC_H

#include "Module.h"

class ModuleInvoke_ThreadExec : public Module {
public:
    ModuleInvoke_ThreadExec(std::string name);
    ModuleInvoke_ThreadExec(const ModuleInvoke_ThreadExec& orig);
    virtual ~ModuleInvoke_ThreadExec();
protected:
    virtual void do_run(Entity* entity);

private:
    void _duplicate(Entity* entity);
};

#endif	/* MODULEINVOKE_THREADEXEC_H */

