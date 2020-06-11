#include "Edge.h"

template<typename NodePayLoad, typename EdgePayLoad>
Edge<NodePayLoad, EdgePayLoad>::Edge(Node<NodePayLoad, EdgePayLoad>* vertFrom, Node<NodePayLoad, EdgePayLoad>* vertTo, EdgePayLoad weight) {
	this->vertFrom = vertFrom;
	this->vertTo = vertTo;
	this->weight = weight;
}

template<typename NodePayLoad, typename EdgePayLoad>
Node<NodePayLoad, EdgePayLoad>* Edge<NodePayLoad, EdgePayLoad>::getVertFrom() const {
	return vertFrom;
}

template<typename NodePayLoad, typename EdgePayLoad>
Node<NodePayLoad, EdgePayLoad>* Edge<NodePayLoad, EdgePayLoad>::getVertTo() const {
	return vertTo;
}

template<typename NodePayLoad, typename EdgePayLoad>
EdgePayLoad Edge<NodePayLoad, EdgePayLoad>::getWeight() const {
	return weight;
}

template<typename NodePayLoad, typename EdgePayLoad>
bool Edge<NodePayLoad, EdgePayLoad>::connects(Node<NodePayLoad, EdgePayLoad>* nodeFirst, Node<NodePayLoad, EdgePayLoad>* nodeSecond) const {
	return ((nodeFirst == this->vertFrom && nodeSecond == this->vertTo) || (nodeFirst == this->vertTo && nodeSecond == this->vertFrom));
}