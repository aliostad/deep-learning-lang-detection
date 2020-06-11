#ifndef STREAMS_H
#define STREAMS_H

typedef INT32 stream_sample_t;
typedef struct _sound_stream sound_stream;

typedef void (*stream_callback)(void *param, stream_sample_t **inputs, stream_sample_t **outputs, int samples);

int streams_init(void);
void streams_set_tag(void *streamtag);
void streams_frame_update(void);

/* core stream configuration and operation */
sound_stream *stream_create(int inputs, int outputs, int sample_rate, void *param, stream_callback callback);
void stream_set_input(sound_stream *stream, int index, sound_stream *input_stream, int output_index, float gain);
void stream_update(sound_stream *stream, int min_interval);	/* min_interval is in usec */
stream_sample_t *stream_consume_output(sound_stream *stream, int output, int samples);

/* utilities for accessing a particular stream */
sound_stream *stream_find_by_tag(void *streamtag, int streamindex);
int stream_get_inputs(sound_stream *stream);
int stream_get_outputs(sound_stream *stream);
void stream_set_input_gain(sound_stream *stream, int input, float gain);
void stream_set_output_gain(sound_stream *stream, int output, float gain);

#endif
