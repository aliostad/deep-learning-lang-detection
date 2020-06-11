//
//  main.cpp
//  TheNewBoston
//
//  Created by Bellchan on 1/16/14.
//  Copyright (c) 2014 Bellchan. All rights reserved.
//

#include <iostream>
#include "PointerSample.h"
#include "DeconstrutorSample.h"
#include "ConstantObjectSample.h"
#include "UnsignedInteger.h"
using namespace std;


void POinterFunctionSample();
void UsingDeconstructorFunction();
void ConstantObjectSampleFunction();

int main(int argc, const char * argv[])
{

    UnsignedInteger unsignedInt;
    
    
    return 0;
}

void POinterFunctionSample(){
    /*
     There are two ways to call a function in another class
     */
    
    //1st using dot operator like java
    PointerSample sampleObject;
    sampleObject.printCrap();
    
    
    //2nd using pointer and arrow member selection operator
    PointerSample *samplePointer;
    samplePointer = &sampleObject;
    
    samplePointer->printCrap();
}

void UsingDeconstructorFunction(){
    
    DeconstrutorSample deconObject;
    cout<<"After this the deconstructor will be called" << endl;
}

void ConstantObjectSampleFunction(){
    ConstantObjectSample sample;
    sample.printShiz();
    
   const ConstantObjectSample sampleConstant;
    sampleConstant.printShiz2();
}


