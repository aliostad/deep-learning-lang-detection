/*
 * chunk.h
 *
 *  Created on: Jan 19, 2015
 *      Author: scho
 */
#include <list>
#include <iterator>

#ifndef CHUNK_H_
#define CHUNK_H_

template<class Value, typename offset_t>
class ChunkIter {
private:
	std::iterator<std::input_iterator_tag, Value> delta_iterator_;

public:
	ChunkIter(offset_t offset);

	Value Next();
	bool HasNext();
};

template<class Value, typename offset_t>
class Chunk {
private:
	offset_t offset_;
	uint32_t size_;
	uint32_t first_;
	std::list<Value> main_set_;
	std::list<Value> delta_set_;
	Chunk* next_;

	std::list<Value> MaterializeDelta();

public:
	Chunk(offset_t offset);
	Chunk(offset_t offset, offset_t next_offset, std::list<Value> set);

	/**
	 * Returns the number of elements in the chunk.
	 * @return the number of elements in the chunk.
	 */
	uint32_t Size();

	/**
	 * Returns the chunk iterator. The iterator should be lazy iterator.
	 * @return the chunk iterator.
	 */
	ChunkIter<Value, offset_t> Iterator();

	bool Encode();

	bool Add(Value value);
};

template<class Value, typename offset_t>
Chunk<Value, offset_t>::Chunk(offset_t offset) {
	Chunk::offset_ = offset;
	// Chunk::next_ = chunk();
	// Read size
}

/**
 * Creates a chunk at given target with initial data. This chunk is created to encode.
 */
template<class Value, typename offset_t>
Chunk<Value, offset_t>::Chunk(offset_t offset, offset_t next_offset,
		std::list<Value> set) {
	Chunk::offset_ = offset;
	Chunk::main_set_ = set;
	Chunk::size_ = main_set_.size();
	Chunk::first_ = main_set_[0];
	Chunk::next_ = chunk(next_offset);
}

template<class Value, typename offset_t>
uint32_t Chunk<Value, offset_t>::Size() {
	return Chunk::size_;
}

#endif /* CHUNK_H_ */
