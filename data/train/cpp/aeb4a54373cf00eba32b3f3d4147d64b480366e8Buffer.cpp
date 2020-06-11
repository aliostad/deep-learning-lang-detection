
#include "buffer.hpp"

namespace cell_stream {

void buffer::init(const u32_t size) {
	
	for (chunk_vector_t::iterator i = _chunk.begin(); i != _chunk.end(); i++) {
		_free_align( *i );
	}
	
	_chunk.resize( size );
	
	for (chunk_vector_t::iterator i = _chunk.begin(); i != _chunk.end(); i++) {
		(*i) = (chunk_t*)_malloc_align( sizeof(chunk_t), 7 );
		(*i)->state = E_CHUNK_FREE;
	}
	
	for (u8_t i = 0; i < E_CHUNK_LENGTH; i++) {
		_index[i]	= 0;
		_count[i]	= 0;
	}
	_count[E_CHUNK_FREE] = _chunk.size();
}

void buffer::step_chunk(chunk_t* chunk, const chunk_state_t current, const chunk_state_t next) {
	boost::mutex::scoped_lock lock1(_mutex[current]);
	boost::mutex::scoped_lock lock2(_mutex[next]);
	
	chunk->state = next;
	_count[current]--;
	_count[next]++;
	
//	cout << "buffer: current = " << (int)current << " next = " << (int)next
//		<< " count[current] = " << _count[current] << " count[next] = " << _count[next] << endl;
}

chunk_t* buffer::find_chunk(const chunk_state_t current, const chunk_state_t next) {
	if ( _count[current] == 0 ) return NULL;

	boost::mutex::scoped_lock lock1(_mutex[current]);
	boost::mutex::scoped_lock lock2(_mutex[next]);

	for (
		u32_t i = _index[current];
		((i + 1) % _chunk.size()) != _index[current];
		i = (i + 1) % _chunk.size()
	) {
		if ( _chunk[i]->state == current ) {
			_chunk[i]->state = next;
			_index[current] = (i + 1) % _chunk.size();
			
			_count[current]--;
			_count[next]++;

//			cout << "buffer: current = " << (int)current << " next = " << (int)next
//				<< " count[current] = " << _count[current] << " count[next] = " << _count[next] << endl;
			
			return _chunk[i];
		}
	}
	
	return NULL;
}

chunk_t* buffer::find_wait_chunk(const u8_t prog_id) {
	if ( _count[E_CHUNK_WAIT] == 0 ) return NULL;

//	cout << "buffer: search prog id " << (int)prog_id << endl;

	boost::mutex::scoped_lock lock1(_mutex[E_CHUNK_WAIT]);
	boost::mutex::scoped_lock lock2(_mutex[E_CHUNK_WORKING]);

	for (
		u32_t i = _index[E_CHUNK_WAIT];
		((i + 1) % _chunk.size()) != _index[E_CHUNK_WAIT];
		i = (i + 1) % _chunk.size()
	) {
		if ( (_chunk[i]->state == E_CHUNK_WAIT) && (_chunk[i]->prog_id == prog_id) ) {
			_chunk[i]->state = E_CHUNK_WORKING;
			_index[E_CHUNK_WAIT] = (i + 1) % _chunk.size();
			
			_count[E_CHUNK_WAIT]--;
			_count[E_CHUNK_WORKING]++;

//			cout << "buffer: current = " << (int)E_CHUNK_WAIT << " next = " << (int)E_CHUNK_WORKING
//				<< " count[E_CHUNK_WAIT] = " << _count[E_CHUNK_WAIT] << " count[E_CHUNK_WORKING] = " << _count[E_CHUNK_WORKING] << endl;
			
			return _chunk[i];
		}
	}
	
	return NULL;	
}
	
}
