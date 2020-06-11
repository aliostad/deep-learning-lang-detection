#include "Node.h"

template<typename NodePayLoad, typename EdgePayLoad>
Node<NodePayLoad, EdgePayLoad>::Node(size_t numb, NodePayLoad inform) {
	this->numb = numb;
	this->inform = inform;
	vecOfEd = new std::vector<Edge<NodePayLoad, EdgePayLoad>*>();
}

template<typename NodePayLoad, typename EdgePayLoad>
size_t Node<NodePayLoad, EdgePayLoad>::getNumb() const {
	return numb;
}

template<typename NodePayLoad, typename EdgePayLoad>
std::vector<Edge<NodePayLoad, EdgePayLoad>*>* Node<NodePayLoad, EdgePayLoad>::getVecOfEd() const {
	return vecOfEd;
}

template<typename NodePayLoad, typename EdgePayLoad>
Node<NodePayLoad, EdgePayLoad>* Node<NodePayLoad, EdgePayLoad>::getPrevious() const {
	return previous;
}

template<typename NodePayLoad, typename EdgePayLoad>
NodePayLoad & Node<NodePayLoad, EdgePayLoad>::getInform() {
	return inform;
}