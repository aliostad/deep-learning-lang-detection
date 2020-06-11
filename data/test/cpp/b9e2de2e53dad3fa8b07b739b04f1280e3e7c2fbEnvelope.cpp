/*  Envelope.cpp
	Velosynth/Arduino envelope class
	for C++/Arduino
*/

#include "Envelope.h"

Envelope::Envelope(unsigned int length, int sampleMin, int sampleMax) {
  this->length = length;
  this->sampleMin = sampleMin;
  this->sampleMax = sampleMax;
}

void Envelope::generateNote(unsigned char note[]) {
  int attack = 200; 
  int decay = 400;
  int sustain = 600;
  int release = 800;
  int sampleMid = sampleMax / 2;
  int val;
  for(int i = 0; i < length; i++) {
    if(i < attack) { // attack phase
      val = map(i, 0, attack, sampleMax, sampleMin);
    }
    if(i > attack) { // decay phase
      val = map(i, attack, decay, sampleMin, sampleMax);
    }
    if(i > decay) { // sustain phase
      val = sampleMid; // see chart!
    }
    if(i > sustain) { // release phase
      val = map(i, sustain, release, sampleMid, sampleMin);
    }
    note[i] = val;
  }
  
  
}