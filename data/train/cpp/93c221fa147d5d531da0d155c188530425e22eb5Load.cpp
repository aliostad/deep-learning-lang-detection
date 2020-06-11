/*
 * Load.cpp
 *	 Source file for the Load.h file
 *  Created on: Nov 25, 2014
 *      Author: kumaar6
 */

#include "Load.h"
#include "Project.h"


Load::Load(){
	//default constructor for the load class
	ID 		= ID_NOT_INIT;
	Status 	= LOAD_NOT_INIT;	//current state of the load
	onTime 	= TIME_NOT_INIT;	// time since load is on
	offTime	= TIME_NOT_INIT;	// time since load is off
	PRIO	= PRIO_NOT_INIT;	// assigned priority
	DPRIO	= PRIO_NOT_INIT;	// Dynamic priority
	ASL		= LOAD_NOT_INIT;	// actual sanctioned load
	DCL		= LOAD_NOT_INIT;	// Currently consuming load
	DL		= LOAD_NOT_INIT;	// demanded load
}

Load::Load(pin_t rpin, pin_t wpin, id_t ID, prio_t prio, load_t load){
	// Parameterized constructor for the load type class
	_rpin = rpin;
	_wpin = wpin;
	pinMode(_wpin, PIN_OUTPUT);

	Status 		= LOAD_INIT;
	this->ID 	= ID;
	this->PRIO 	= prio;
	DL	 		= load;
	onTime 		= TIME_NOT_INIT;	// time since load is on
	offTime 	= TIME_NOT_INIT;	// time since load is off
	ASL	 		= LOAD_NOT_INIT;	// actual sanctioned load
	DCL	 		= LOAD_NOT_INIT;	// Currently consuming load
}

uint16_t Load::readLoad(void){
	// just return the analog values
	return analogRead(_rpin);
}

status_t Load::writeLoad(uint8_t Logic){

	if(Logic != State){ // if a new state has been requested
		State 	= Logic;	// change the state
		onTime 	= TIME_RESET;	// reset the timers
		offTime = TIME_RESET;	// reset the timers
	}

	digitalWrite(_wpin, State);
	return State;
}

status_t Load::setLoadStatus(uint8_t Logic){
	// write the requested value to the pin
	return State = Logic;
}

status_t Load::getLoadStatus(void){
	return State;
}

status_t Load::setLoadState(LoadState_t* state){
	/*
	 * This methods sets he load values as requested
	 */
	this->ID 		= state->ID;
	this->PRIO 		= state->PRIO;
	this->State 	= state->State;
	this->ASL 		= state->ASL;
	this->DCL	 	= state->DCL;

	return LOAD_INIT;
}

status_t Load::getLoadState(LoadState_t *Buf){
	Buf-> ID 		= this-> ID;
	Buf-> State		= this-> State;	//current state of the load
	Buf-> onTime	= this-> onTime;	// time since load is on
	Buf-> offTime	= this-> offTime;	// time since load is off
	Buf-> PRIO		= this-> PRIO;	// assigned priority
	Buf-> DPRIO		= this-> DPRIO;	// Dynamic priority
	Buf-> ASL		= this-> ASL;	// actual sanctioned load
	Buf-> DCL		= this-> DCL;	// Currently consuming load
	Buf-> DL		= this-> DL;	// demanded load

	return LOAD_INIT;
}

prio_t Load::getLoadPrio(void){
	/*
	 * return the dynamic priority as of now
	 */
	return DPRIO;
}

void Load::logic(void){
	static uint16_t loadTicks = 0;

	if(LOAD_ON == State){
			/*
			 * Set the On/OffTime, on every tenth call to the task
			 * this increments by one
			 */
			if(!(loadTicks %10)){	// on each multiple of 10 ticks
				onTime++;
			}

			if(DPRIO < PRIO){	// If currently at higher priority than the
				DPRIO += PRIO_STEP_SIZE;
			}

			if(DPRIO > PRIO){
				DPRIO = PRIO;	//if the value overshoots
			}
		}


	if(LOAD_OFF == State){
			/*
			 * Set the On/OffTime, on every tenth call to the task
			 * this increments by one
			 */
			if(!(loadTicks %10)){
				offTime++;
			}

			DPRIO -= PRIO_STEP_SIZE;	//Increasse the priority if load is off

			if(LOAD_MAX_PRIO > DPRIO){
				DPRIO = LOAD_MAX_PRIO;	// if the value undershoots
			}
		}

	loadTicks ++;
}

status_t Load::Task(void){
	//Debug
	//Serial.write("Inside Load Task\n");
	/*
	 * Task  that is executed cyclically for every load
	 * Tasks to be done:
	 * 1. Read Current Load
	 * 2. Adjust priority
	 */
	//TASK1:
	readLoad();
	//Task2:
	logic();

	//Debug
	//Serial.write("Exit  Load Task\n");

	return Status;
}




