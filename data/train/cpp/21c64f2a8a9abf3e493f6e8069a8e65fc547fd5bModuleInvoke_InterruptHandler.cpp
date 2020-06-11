/*
 * File:   ModuleInvoke_InterruptHandler.cpp
 * Author: cancian
 *
 * Created on October 9, 2015, 2:51 PM
 */

#include "ModuleInvoke_InterruptHandler.h"
#include "Simulator.h"
#include "Simul_Debug.h"
#include "Mediator_Timer.h"

ModuleInvoke_InterruptHandler::ModuleInvoke_InterruptHandler(std::string name) : Module(name) {
}

ModuleInvoke_InterruptHandler::ModuleInvoke_InterruptHandler(const ModuleInvoke_InterruptHandler& orig) : Module(orig) {
}

ModuleInvoke_InterruptHandler::~ModuleInvoke_InterruptHandler() {
}

void ModuleInvoke_InterruptHandler::do_run(Entity* entity) {
    Simulator* simulator = Simulator::getInstance();
    Debug::cout(Debug::Level::info, this, entity, "Timer interrupt handler invoked");
    Timer::interrupt_handler();

    Module* nextModule = *(this->_nextModules->begin());
    simulator->insertEvent(simulator->getTnow(), nextModule, entity);
}