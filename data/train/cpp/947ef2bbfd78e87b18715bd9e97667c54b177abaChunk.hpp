/**
 * Cell stream source
 */

#pragma once

#include "../../common.h"

#include <list>
#include <boost/signal.hpp>

using namespace std;

namespace cell_stream {

// Typedefs

typedef boost::signal<void (chunk_t*)> chunk_signal_t;

// CSChunkSource

class chunk_source {

public:
	chunk_source() { }
	virtual ~chunk_source() { }

	chunk_signal_t&		signal_chunk_generated(void) { return on_chunk_generated; }

protected:
	chunk_signal_t		on_chunk_generated;

};

typedef list<chunk_source*>	chunk_source_list_t;

// CSChunkDestination

class chunk_destination {

public:
	chunk_destination() { }
	virtual ~chunk_destination() { }

	virtual void	chunk_received(const chunk_t*) { }
	
};

typedef list<chunk_destination*>	chunk_destination_list_t;

}
