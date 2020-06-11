#include "Arduino.h"
#include "Dumping.h"
#include "Servo.h" // Arduino Servo library

#define DUMP_SERVO_MIN           175// perp to servo
#define DUMP_SERVO_MAX           65 // CCW from top
#define DUMP_SERVO_INTERVAL      110 // if this is too large does it explode? // why did it explode?

#define DUMP_SERVO_EXTENDING     0
#define DUMP_SERVO_RETRACTING    1


static unsigned char dumping_pin; // pwm
static Servo dump_servo;
static int dump_position = DUMP_SERVO_MIN;
static unsigned char dump_current_servo_direction;


void dumping_init( unsigned char dumping){
    dumping_pin = dumping;
    dump_servo.attach(dumping_pin);
    dump_servo.write(DUMP_SERVO_MIN);
    dump_current_servo_direction = DUMP_SERVO_EXTENDING;
};

// extends the servo a bit
void extend_dumper(){
    dump_position -= DUMP_SERVO_INTERVAL;
    dump_servo.write(dump_position);
    Serial.print("Extended to pos: ");
    Serial.println(dump_position);
    dump_current_servo_direction = DUMP_SERVO_EXTENDING;
}


// retracts the servo a bit
void retract_dumper(){
    dump_position += DUMP_SERVO_INTERVAL;
    
    dump_servo.write(dump_position);
    Serial.print("Retracted to pos: ");
    Serial.println(dump_position);
    dump_current_servo_direction = DUMP_SERVO_RETRACTING;
}

// should return true if finished moving in any direction
unsigned char dumper_finished(){
    if (dump_current_servo_direction == DUMP_SERVO_EXTENDING){
        return (dump_position <= DUMP_SERVO_MAX);
    } else if (dump_current_servo_direction == DUMP_SERVO_RETRACTING) {
        return (dump_position >= DUMP_SERVO_MIN);
    }
    return true; 
}

