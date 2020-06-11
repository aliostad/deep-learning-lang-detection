#ifndef NODE_H
#define NODE_H

#include "Graph.h"
#include "Edge.h"

#include <vector>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <string>
#include <functional>

template<typename NodePayLoad, typename EdgePayLoad>
class Edge;

template<typename NodePayLoad, typename EdgePayLoad>
class Graph;

template<typename NodePayLoad, typename EdgePayLoad>
class Node {
	friend class Edge<NodePayLoad, EdgePayLoad>;

	friend class Graph<NodePayLoad, EdgePayLoad>;
	
private:
	size_t numb;
	std::vector<Edge<NodePayLoad, EdgePayLoad>*>* vecOfEd;
	Node<NodePayLoad, EdgePayLoad>* previous;
	NodePayLoad inform;

public:

	// constructor
	Node(size_t numb, NodePayLoad inform);

	// destructor
	~Node() {
	}

	// Returns numb of node
	size_t getNumb() const;

	// Returns vector of edges, that starts in this vertexes
	std::vector<Edge<NodePayLoad, EdgePayLoad>*>* getVecOfEd() const;

	// Returns previous node
	Node<NodePayLoad, EdgePayLoad>* getPrevious() const;

	// Returns inform from node
	NodePayLoad &getInform();
};

#endif