// -*- mode:C++; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

/* 
 * Copyright (C) 2011 Department of Robotics Brain and Cognitive Sciences - Istituto Italiano di Tecnologia
 * Author: Ugo Pattacini
 * email:  ugo.pattacini@iit.it
 * Permission is granted to copy, distribute, and/or modify this program
 * under the terms of the GNU General Public License, version 2 or any
 * later version published by the Free Software Foundation.
 *
 * A copy of the license can be found at
 * http://www.robotcub.org/icub/license/gpl.txt
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details
*/

#include "predModels.h"

using namespace yarp::sig;


//namespace logpolar
//{

//namespace predictor
//{


genPredModel::genPredModel() {
    valid = true;
    type = "constVelocity";
    
}

genPredModel::genPredModel(const genPredModel &model) {
    valid = true;
    type = "constVelocity";
}

genPredModel &genPredModel::operator =(const genPredModel &model) {
    valid = model.valid;
    type  = model.valid;
    A = model.A;
    B = model.B;
    return *this;
}

bool genPredModel::operator ==(const genPredModel &model) {
    return ((valid==model.valid)&&(type==model.type)&&(A==model.A)&&(B==model.B)); 
}

void genPredModel::init(double param) {
    printf("genPredModel::init: start \n");
    Matrix _A(3,3);
    Matrix _B(3,3);
    A = _A;
    B = _B;   
    A.zero();
    B.zero();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

linVelModel::linVelModel() {
    valid = true;
    type = "constVelocity";
    
}

linVelModel::linVelModel(const linVelModel &model) {
    valid = true;
    type = "constVelocity";
}

linVelModel &linVelModel::operator =(const linVelModel &model) {
    valid = model.valid;
    type  = model.valid;
    A = model.A;
    B = model.B;
    return *this;
}

bool linVelModel::operator ==(const linVelModel &model) {
    return ((valid==model.valid)&&(type==model.type)&&(A==model.A)&&(B==model.B)); 
}

void linVelModel::init(double param) {
    printf("linVelModel::init: start \n");
    Matrix _A(3,3);
    Matrix _B(3,3);
    A = _A;
    B = _B;
    
    A.zero();
    B.zero();
    //B(0,0) = 1;
    B(0,0) = param;
    printf("linVelModel::init : end \n");
}
 
//////////////////////////////////////////////////////////////////////////////////////////////////////


linAccModel::linAccModel() {
    valid = true;
    type = "constAcceleration";
}

linAccModel::linAccModel(const linAccModel &model) {
    valid = true;
    type = "constAcceleration";
}

linAccModel &linAccModel::operator =(const linAccModel &model) {
    valid = model.valid;
    type  = model.valid;
    A = model.A;
    B = model.B;
    return *this;
}

bool linAccModel::operator ==(const linAccModel &model) {
    return ((valid == model.valid) && (type == model.type) && (A == model.A) && (B == model.B)); 
}

void linAccModel::init(double param) {
    printf("linAccModel::init: start \n");
    Matrix _A(3,3);
    Matrix _B(3,3);
    A = _A;
    B = _B;

    A.zero();
    B.zero();
    //B(1,1) = 1;
    B(1,1) = param;  // as using always the same speed the output matrix changes
    printf("linAccModel::init: stop \n");
}


//////////////////////////////////////////////////////////////////////////////////////////////////////


minJerkModel::minJerkModel() {
    valid = true;
    type = "minimumJerk";
    
}

minJerkModel::minJerkModel(const minJerkModel &model) {
    valid = true;
    type = "minimumJerk";
    A = model.A;
    B = model.B;
}

minJerkModel &minJerkModel::operator =(const minJerkModel &model) {
    valid = model.valid;
    type  = model.valid;
    A = model.A;
    B = model.B;
    return *this;
}

bool minJerkModel::operator ==(const minJerkModel &model) {
    return ((valid == model.valid) && (type == model.type) 
            && (A == model.A)&&(B == model.B)); 
}

void minJerkModel::init(double param) {
    printf("minJerkModel::init:start \n");
    T = param;
    //a = -150.7659;
    //b = -84.9813;
    //c = -15.9670;
    
    Matrix _A(3,3);
    Matrix _B(3,3);
    A = _A;
    B = _B;

    A.zero();
    B.zero();
    
    A(0,1) = 1;
    A(1,2) = 1;
    A(2,0) = a / (T * T * T);
    A(2,1) = b / (T * T);
    A(2,2) = c / (T);

    B(2,2) = a / (T * T * T);
    printf("minJerkModel::init:stop \n");
}
