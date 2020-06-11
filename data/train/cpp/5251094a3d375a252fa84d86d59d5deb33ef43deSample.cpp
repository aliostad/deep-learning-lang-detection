#include <iostream>
#include "Sample.h"


//****************************************************
// Sample Class - Stores info about the sample
//****************************************************

Sample::Sample() {
    this->x = 0;
    this->y = 0;
}
Sample::Sample(int a, int b) {
    this->x = a;
    this->y = b;  
}

void Sample::print() {
    std::cout << "[" << this->x << ", " << this->y << "]" << std::endl;
}

void Sample::setSample(int a, int b) {
    this->x = a;
    this->y = b;
}

/*
int main(int argc, char* argv[]){
    Sample* sampl = new Sample(45, 68);

    std::cout << "Sample 1: " << std::endl;
    sampl->print(); 

}
*/

