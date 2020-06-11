package main

import (
	"./EventManager"
	"fmt"
	"time"
)

func main() {
	if EventManager.Elevator_init() != 1 {
		fmt.Println("Uanble to initialize elevator hardware... \n")
		return
	}
	for EventManager.Elevator_get_floor_sensor_signal() == -1 {
		EventManager.Statemachine_set_state_and_dir(EventManager.MOVING, EventManager.MOTOR_DIR_UP)
	}
	EventManager.Statemachine_set_state_and_dir(EventManager.IDLE, EventManager.MOTOR_DIR_STOP)
	for {
		EventManager.Eventmanager_check_button_signal()
		EventManager.Statemachine_set_current_floor()
		EventManager.Statemachine_set_button_lights()
		EventManager.Eventmanager_new_order_in_empty_queue()
		EventManager.Eventmanager_arrive_at_floor()
		EventManager.Eventmanager_door_timeout()
		EventManager.Eventmanager_orders_in_same_floor()
		time.Sleep(400 * time.Millisecond)
	}
}
