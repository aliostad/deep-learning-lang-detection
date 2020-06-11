/*
 * locatorSortArray.h
 *
 *  Created on: 2013-04-09
 *      Author: jun
 */

#ifndef LOCATORSORTARRAY_H_
#define LOCATORSORTARRAY_H_

#include "locator.h"
#include "iterator.h"
#include "array.h"
template <typename T>
class LocatorSortArray : public Locator<T>
{
public:
	Node<T>* locate(Iterator<T>* it,T value);
	~LocatorSortArray(){};
};

template <typename T>
Node<T>* LocatorSortArray<T>::locate(Iterator<T>* it,T value)
{
	Node<T>* head = it->current();
	Node<T>* res = head;
	while(it->hasNext())
	{
		res = it->current();
		if(value < it->next())	break;

		if (it->current()->next() == head)
		{
			res = it->current();
			break;
		}
	}
	return res;
}


#endif /* LOCATORSORTARRAY_H_ */
