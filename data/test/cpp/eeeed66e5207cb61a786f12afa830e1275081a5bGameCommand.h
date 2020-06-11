#ifndef GAMECOMMAND_H
#define GAMECOMMAND_H

//#include "Model.h"
#include <iostream>
using namespace std;

class Model;

void do_sail_command(Model* model);
void do_go_command(Model* model);
void do_run_command(Model* model);
void do_port_command(Model* model);
void do_hide_command(Model* model);
void do_anchor_command(Model* model);
void do_list_command(Model* model);
void do_dock_command(Model* model);
void plUnder(Model* model);
void handle_new_command(Model* model);
void savecommand(Model* model);
void restorecommand(Model* model);
#endif