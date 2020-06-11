/*****************************************************************************
 * 
 * SAMPLE.CXX
 *
 * Sample Class
 *
 * R. Kwan
 * August 3, 1995
 *
 * (C) Copyright 1995 by R.Kwan
 *
 *****************************************************************************/

// $Header: /private-cvsroot/simulation/mrisim/src/signal/sample.cxx,v 1.2 2008-11-06 10:58:23 rotor Exp $
// $Log: sample.cxx,v $
// Revision 1.2  2008-11-06 10:58:23  rotor
//  * fixed includes for iostream and friends
//  * updated for new release (1.0.2)
//
// Revision 1.1  2003/05/30 16:43:14  bert
// Initial checkin, mrisim 3.1 from Remi Kwan's home directory
//
// Revision 2.3  1996/01/17  17:57:21  rkwan
// Updated _print_sample.
//
// Revision 2.2  1995/12/11  14:27:23  rkwan
// Updated for fast_iso_model.
//
// Revision 2.1  1995/08/08  14:45:44  rkwan
// Updated for new spin model and pulse sequence.
//

#include "sample.h"
#include <stdio.h> 
#include <iostream>
#include <iomanip>

/*****************************************************************************
 * Sample Class
 *****************************************************************************/

/*****************************************************************************
 * Sample constructors
 *****************************************************************************/

Sample::Sample() : Event() {
   _save_sample = &Sample::_print_sample;
   _event_type = SAMPLE;
   _clientData = this;
}

Sample::Sample(Time_ms t) : Event(t) {
   _save_sample = &Sample::_print_sample;
   _event_type = SAMPLE;
   _clientData = this;
}
 
Sample::Sample(Time_ms t, void (*f)(Vector_3D&,void *), void *data) 
   : Event(t) {
   _save_sample = f;
   _clientData  = data;
   _event_type = SAMPLE;
}

Sample::Sample(const Sample& s) : Event((Event&)s) {
   _save_sample = s._save_sample;
   _clientData  = s._clientData;
}
   
/*****************************************************************************
 * Sample::apply
 * Sample the magnetization vector at the event time.
 *****************************************************************************/

Vector_3D& Sample::apply(Spin_Model& m){
   static Vector_3D sample;

   m.update(_event_time);
   sample = m.get_net_magnetization();
   _save_sample(sample, _clientData);
   return sample;
}

void Sample::get_descriptor_string(char s[]){

   sprintf((char *)s,"Sample %8.2lf",(double)_event_time);

}

Event *Sample::make_new_copy_of_event(void){
   return (Event *)new Sample(*this);
}

/*****************************************************************************
 * Sample::_print_sample
 * Default save sample method.  Displays the sample on stdout.
 *****************************************************************************/

void Sample::_print_sample(Vector_3D& m, void *clientData){

   Sample *sample = (Sample *)clientData;
   cout << "Time: " << setw(4) << (double)sample->_event_time << " ms "
        << "X: " << setprecision(6) << m[X_AXIS] << " "
        << "Y: " << setprecision(6) << m[Y_AXIS] << " "
        << "Z: " << setprecision(6) << m[Z_AXIS] << " " 
        << "XY: " << setprecision(6) << hypot(m[X_AXIS],m[Y_AXIS]) << endl;
}

