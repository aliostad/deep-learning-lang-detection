#ifndef MChunk_h__
#define MChunk_h__

#include "Chunk.h"

template <class Meat>
class MChunk {
public:
	MChunk (Chunk<Meat> *_chunk) {
		this->chunk = _chunk;
		this->chunk->Use ();
	}

	MChunk (const MChunk<Meat>& _other) {
		this->chunk = _other.chunk;
		this->chunk->Use ();
	}

	MChunk& operator= (const MChunk<Meat>& _other) {
		this->chunk = _other.chunk;
		this->chunk->Use ();
		return *this;
	}

	~MChunk() {
		if (this->chunk != nullptr) {
			this->chunk->DisUse ();
		}
	}

	MChunk () {
		this->chunk = nullptr;
	}

	inline Chunk<Meat> *GetChunk () { return this->chunk; }
	inline void SetChunk (Chunk<Meat> *_chunk) { 
		if (this->chunk != nullptr) {
			this->chunk->DisUse ();
		}
		this->chunk = _chunk; 
		this->chunk->Use ();
	}

private:
	Chunk<Meat> *chunk;		// The chunk that is managed by this ManagedChunk
};

#endif // MChunk_h__
