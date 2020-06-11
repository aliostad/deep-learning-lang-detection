/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   ModuleInvoke_DiskScheduler.cpp
 * Author: cancian
 * 
 * Created on 29 de Agosto de 2016, 12:18
 */

#include "ModuleInvoke_DiskScheduler.h"

#include "Simulator.h"

ModuleInvoke_DiskScheduler::ModuleInvoke_DiskScheduler(std::string name): Module(name) {
}

ModuleInvoke_DiskScheduler::ModuleInvoke_DiskScheduler(const ModuleInvoke_DiskScheduler& orig): Module(orig) {
}

ModuleInvoke_DiskScheduler::~ModuleInvoke_DiskScheduler() {
}

void ModuleInvoke_DiskScheduler::do_run(Entity* entity) {
    Simulator* simulator = Simulator::getInstance();
}
