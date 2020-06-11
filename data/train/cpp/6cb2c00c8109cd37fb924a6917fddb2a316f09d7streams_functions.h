/*
 * streams_functions.h
 *
 * \brief wrapper functions with pointer checks for stream interface
 * 
 * Created: 07/06/2012 21:07:26
 *  Author: sfx
 */


#ifndef STREAM_FUNCTIONS_H_
#define STREAM_FUNCTIONS_H_

#include "streams.h"

#include "error_handler.h"

// convenience functions with pointer checks

static uint8_t inline bytestream_get(byte_stream_t *stream) {
	RUN_IF((stream->get!=NULL),STREAM_ERROR, WARNING, "stream get: null pointer\n")  {
		return stream->get(stream->data);
	}
	return 0;
}

static int8_t inline bytestream_put(byte_stream_t *stream, uint8_t element) {
	RUN_IF((stream->put!=NULL),STREAM_ERROR, WARNING, "stream put: null pointer\n")  {
		stream->put(stream->data, element);
		return 1;
	}
	return -1;
}

static void inline bytestream_flush(byte_stream_t *stream) {
	RUN_IF((stream->flush!=NULL),STREAM_ERROR, WARNING, "stream flush: null pointer\n")  {
		stream->flush(stream->data);
	}
}

static void inline bytestream_start_transmission(byte_stream_t *stream) {
	RUN_IF((stream->start_transmission!=NULL),STREAM_ERROR, WARNING, "stream start transmission: null pointer\n")  {
		stream->start_transmission(stream->data);
	}
}

static void inline bytestream_clear(byte_stream_t *stream) {
	RUN_IF((stream->clear_stream!=NULL),STREAM_ERROR, WARNING, "stream clear: null pointer\n")  {
		stream->clear_stream(stream->data);
	}
}


static bool inline bytestream_buffer_empty(byte_stream_t *stream) {
	RUN_IF((stream->buffer_empty!=NULL),STREAM_ERROR, WARNING, "stream buffer_empty: null pointer\n")  {
		return stream->buffer_empty(stream->data);
	}
	return false;
}

static int inline bytestream_bytes_available(byte_stream_t *stream) {
	RUN_IF((stream->bytes_available!=NULL),STREAM_ERROR, WARNING, "stream bytes_available: null pointer\n")  {
		return stream->bytes_available(stream->data);
	}
	return -1;
}



typedef struct packet_t {
	char *data;
	int size;
} packet_t;

typedef struct packet_stream_t {
	packet_t (*get)(stream_data_t *data); // returns a received packet into outbuffer
	int		(*put)(stream_data_t *data, packet_t *packet);
	int     (*buffer_empty)(stream_data_t *data);
	int     (*packets_available)(stream_data_t *data);
	volatile stream_data_t data;
} packet_stream_t;


static packet_t inline packet_get(packet_stream_t *stream) {
	RUN_IF((stream->put!=NULL),STREAM_ERROR, CRITICAL, "stream bytes_available: null pointer")  {
		return stream->get(stream->data);
	}
}

static int inline packet_send(packet_stream_t *stream, packet_t *packet) {
	RUN_IF((stream->put!=NULL),STREAM_ERROR, CRITICAL, "stream bytes_available: null pointer")  {
		return stream->put(stream->data, packet);
	}
	return -1;
}

static int inline packetstream_buffer_empty(packet_stream_t *stream) {
	RUN_IF((stream->buffer_empty!=NULL),STREAM_ERROR, CRITICAL, "stream buffer_empty: null pointer")  {
		return stream->buffer_empty(stream->data);
	}
	return -1;
}

static int inline packetstream_packets_available(packet_stream_t *stream) {
	RUN_IF((stream->buffer_empty!=NULL),STREAM_ERROR, CRITICAL, "stream bytes_available: null pointer")  {
		return stream->packets_available(stream->data);
	}
	return -1;
}






#endif
