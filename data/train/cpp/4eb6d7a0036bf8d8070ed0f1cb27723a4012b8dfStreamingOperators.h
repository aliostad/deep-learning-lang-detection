#ifndef STREAMINGOPERATORS_H
#define STREAMINGOPERATORS_H

#include <iostream>
#include <fstream>
#include <utility>
#include <vector>
#include <list>
#include <map>

#include "BinaryStream.h"
#include "Direction.h"

template<class T>
BinaryStream &operator <<(BinaryStream &stream, std::list<T> &list)
{
	unsigned int size = list.size();
	stream << size;

	for(T &t : list)
	{
		stream << t;
	}

	return stream;
}

template<class T>
BinaryStream &operator >>(BinaryStream &stream, std::list<T> &list)
{
	unsigned int size = 0;
	stream >> size;

	for(unsigned int i = 0; i < size; i++)
	{
		T t;
		stream >> t;

		list.push_back(t);
	}

	return stream;
}

template<class T>
BinaryStream &operator >>(BinaryStream &stream, std::vector<T> &vector)
{
	unsigned int size = 0;
	stream >> size;

	for(unsigned int i = 0; i < size; i++)
	{
		T t;
		stream >> t;

		vector.push_back(t);
	}

	return stream;
}

template<class TKey, class TValue>
BinaryStream &operator >>(BinaryStream &stream, std::map<TKey, TValue> &map)
{
	unsigned int size = 0;
	stream >> size;

	for(unsigned int i = 0; i < size; i++)
	{
		TKey key;
		TValue value;

		stream >> key;
		stream >> value;

		map[key] = value;
	}

	return stream;
}

template<class TFirst, class TSecond>
BinaryStream &operator >>(BinaryStream &stream, std::pair<TFirst, TSecond> &pair)
{
	stream >> pair.first;
	stream >> pair.second;

	return stream;
}

#endif // STREAMINGOPERATORS_H
