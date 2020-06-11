// #pragma once 
#include "Vertex.h"

#ifndef EDGE_H
#define EDGE_H

#include <iostream>
#include <vector>
#include "locator.h"

using namespace std;

//Credits: Original header by Professor Leyk.

class Vertex;

class Edge {

private:

	Vertex *sVertP; // source vertex pointer
	Vertex *eVertP;  // end vertex pointer
	locator <Vertex*> * e_loc; //The locator associated with the end vertex of this edge.
	int weight; // edge weight 
public:
    
	Edge();
	Edge(Vertex* svert, Vertex* evert,int weit);	
	int getWeight();
	Vertex* getsVertP();
	Vertex* geteVertP();
	void set_out_locator(locator<Vertex*> * loc);
	locator <Vertex*> * get_out_locator();
	void terminate_out_locator();
};

#endif