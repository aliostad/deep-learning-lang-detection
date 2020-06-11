/*
 * locatorSort.h
 *
 *  Created on: 2013-03-23
 *      Author: jun
 */

#ifndef LOCATORSORT_H_
#define LOCATORSORT_H_

#include "locator.h"
#include "iterator.h"
#include "array.h"
template <typename T>
class LocatorSort : public Locator<T>
{
public:
	Node<T>* locate(Iterator<T>* it,T value);
	~LocatorSort(){};
};

template <typename T>
Node<T>* LocatorSort<T>::locate(Iterator<T>* it,T value)
{
	Node<T>* head = it->current();
	Node<T>* res = head;
	while(it->hasNext())
	{
		res = it->current();
		if(value < it->next())
			break;
		if (it->current()->next() == head)
		{
			res = it->current();
			break;
		}
	}
	return res;
}

#endif /* LOCATORSORT_H_ */
