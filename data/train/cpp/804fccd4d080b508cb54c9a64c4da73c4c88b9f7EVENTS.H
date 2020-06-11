#ifndef EVENTS_H
#define EVENTS_H

#include "model.h"

/* Model Events */

/* Tank */
void event_tank_move_right(Model *model);
void event_tank_move_left(Model *model);
int event_tank_alive(Model *model);
void event_tank_fire_rocket(Model *model);
void event_move_tank_rocket(Model *model);

/* Rocket */
void event_move_rocket(Model *model);

/* Swarm */
int event_swarm_alive(Model *model);
int event_move_swarm(Model *model);
void event_swarm_fire_rocket(Model *model);
void event_move_swarm_rocket(Model *model);

#endif