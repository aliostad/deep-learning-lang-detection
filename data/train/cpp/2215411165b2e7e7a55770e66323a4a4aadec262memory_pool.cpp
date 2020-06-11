// crt
#include <assert.h>
#include <malloc.h>
// std
#include <new>

#include "memory_pool.h"

using namespace kaynine;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool MemoryPool::reserve(const unsigned kbytes) {
	discard();

	data_ = ::malloc(kbytes * 1024);
	if (!data_)
		return false;

	first_ = biggest_ = smallest_ = new (alignUp(data_)) Chunk;
	// TODO: correct possibly unaligned data_
	last_ = new (alignDown((unsigned)data_ + kbytes * 1024 - sizeof(Chunk))) Chunk;

	reset();

	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void MemoryPool::reset() {
	// cross-link the ends
	first_->prev = 0;
	first_->next = last_;
	last_->prev = first_;
	last_->next = 0;

	// only one free chunk
	first_->smaller = first_->bigger = 0;
	last_->markOccupied();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void MemoryPool::discard() {
	if (data_) {
		::free(data_);
		data_ = 0;
	}
	first_ = last_ = biggest_ = smallest_ = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void* MemoryPool::allocate(const unsigned bytes) {
	assert(data_ && bytes);

	Chunk* chunk = findFreeChunk(bytes);
	if (!chunk)
		return 0;

	unlinkBySize(chunk);
	chunk->markOccupied();

	// set up the left-over chunk
	void* leftover = alignUp((unsigned)chunk + sizeof(Chunk) + bytes);
	if (leftover != (void*)chunk->next) {
		Chunk* leftChunk = new (leftover) Chunk;

		// relink neighbors to the new one after the chunk
		leftChunk->next = chunk->next;
		if (leftChunk->next)
			leftChunk->next->prev = leftChunk;
		leftChunk->prev = chunk;
		chunk->next = leftChunk;

		linkBySize(leftChunk);
	}

	DEBUG_ONLY(checkStructure());

	return chunk + 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void MemoryPool::deallocate(void* data) {
	assert(data_ && data);

	Chunk* chunk = reinterpret_cast<Chunk*>(data) - 1;
	assert(chunk >= first_ && chunk < last_);

	// merge with prev?
	Chunk* check = chunk->prev;
	if (check && (check->bigger != check || check->smaller != check)) {
		check->next = chunk->next;
		chunk->next->prev = check;

		chunk = check;
		unlinkBySize(chunk);
	}

	// merge with next?
	check = chunk->next;
	if (check && (check->bigger != check || check->smaller != check)) {
		check->next->prev = chunk;
		chunk->next = check->next;

		unlinkBySize(check);
	}

	linkBySize(chunk);

	DEBUG_ONLY(checkStructure());
}


#ifdef K9_MEMORYPOOL_STATS

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void MemoryPool::logStructure(Logger& logger, bool contents UNUSED(= false), bool empty UNUSED(= false)) const {
	logger.write(_T("\n|=== Memory Pool == %p =================================|"), data_);
	logger.write(_T("\n| chunk |  size   |  start   |   less   |   more   |   data   |"));
	logger.write(_T("\n|-------------------------------------------------------------|"));

	unsigned iChunk = 0;
	for (Chunk* chunk = first_; chunk && chunk->next; chunk = chunk->next, ++iChunk) {
		if (chunk->isOccupied()) {

			logger.write(_T("\n| %5d | %7d | %p | %p |"), iChunk, chunk->dataSize(), chunk, chunk->data());

			if (contents)
				logContents(logger, chunk);
		} else {
			logger.write(_T("\n| %5d | %7d | %p | %p | %p |          |"), iChunk, chunk->dataSize(), chunk, chunk->smaller, chunk->bigger);

			if (contents && empty)
				logContents(logger, chunk);
		}
	}
	logger.write(_T("\n|=============================================================|\n"), data_);
}

//---------------------------------------------------------------------------------------------------------------------

void MemoryPool::logContents(Logger& logger, Chunk* chunk) const {
	const unsigned colInts = 4;
	const unsigned contentsInts = 8 * colInts;

	for (unsigned i = 0; i < chunk->dataSize() / sizeof(unsigned); ++i) {
		if (i && i % contentsInts == 0)
			logger.write(_T("\n|                                                             |"));

		if (i % colInts == 0)
			logger.write(_T(" "));

		logger.write(_T("%08x "), ((unsigned*)chunk->data())[i]);
	}
}

#endif


//---------------------------------------------------------------------------------------------------------------------

inline MemoryPool::Chunk* MemoryPool::findFreeChunk(const unsigned bytes) const {
	Chunk* freeChunk = 0;

	// TODO: switch direction
	for (Chunk* check = biggest_; check; check = check->smaller) {
		assert(check->bigger != check && check->smaller != check);

		if (check->dataSize() < bytes)
			break;

		freeChunk = check;
	}

	return freeChunk;
}

//---------------------------------------------------------------------------------------------------------------------

inline void MemoryPool::linkBySize(Chunk* chunk) {
	assert(chunk);

	// no free chunks yet?
	if (!biggest_ || !smallest_) {
		assert(!biggest_ && !smallest_);

		chunk->bigger = 0;
		chunk->smaller = 0;

		biggest_ = chunk;
		smallest_ = chunk;
	}
	// is new chunk the smallest one?
	else if (chunk->dataSize() < smallest_->dataSize()) {
		chunk->bigger = smallest_;
		chunk->smaller = 0;

		chunk->bigger->smaller = chunk;
		smallest_ = chunk;
	}
	// is new chunk the biggest one?
	else if (chunk->dataSize() > biggest_->dataSize()) {
		chunk->bigger = 0;
		chunk->smaller = biggest_;

		chunk->smaller->bigger = chunk;
		biggest_ = chunk;
	}
	// somewhere midway - find the next bigger chunk and insert current as its previous
	else {
		Chunk* bigger = findFreeChunk(chunk->dataSize());
		assert(bigger);

		chunk->bigger = bigger;
		chunk->smaller = bigger->smaller;

		chunk->bigger->smaller = chunk;
		chunk->smaller->bigger = chunk;
	}
}

//---------------------------------------------------------------------------------------------------------------------

inline void MemoryPool::unlinkBySize(Chunk* chunk) {
	assert(chunk);

	// is it the only one?
	if (chunk == biggest_ && chunk == smallest_) {
		biggest_ = 0;
		smallest_ = 0;
	}
	// is it smallest?
	else if (chunk == smallest_) {
		smallest_ = chunk->bigger;
		smallest_->smaller = 0;
	}
	// is it biggest?
	else if (chunk == biggest_) {
		biggest_ = chunk->smaller;
		biggest_->smaller = 0;
	}
	// somewhere midway
	else {
		chunk->bigger->smaller = chunk->smaller;
		chunk->smaller->bigger = chunk->bigger;
	}
}

//---------------------------------------------------------------------------------------------------------------------

#ifdef _DEBUG
void MemoryPool::checkStructure() {
	assert(first_->prev == NULL && last_->next == NULL);
	for (Chunk* chunk = first_; chunk->next; chunk = chunk->next)
		assert(chunk->next->prev == chunk);

	assert(smallest_->smaller == NULL && biggest_->bigger == NULL);
	for (Chunk* chunk = smallest_; chunk->bigger; chunk = chunk->bigger)
		assert(chunk->bigger->smaller == chunk && chunk->bigger->dataSize() >= chunk->dataSize());
}
#endif

//---------------------------------------------------------------------------------------------------------------------
