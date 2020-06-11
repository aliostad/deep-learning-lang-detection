/**
 * 
 * @author goldolphin
 *         2015-05-02 22:07
 */
#ifndef EVO_CHAR_STREAM_H
#define EVO_CHAR_STREAM_H

#include <stdio.h>
#include "source_info.h"
#include "character.h"

typedef struct stream_s {
    error_t (* peek)(struct stream_s * s, char_t *c);
    error_t (* poll)(struct stream_s * s, char_t *c);
    source_info_t * (* source_info)(struct stream_s *);
} stream_t;

static inline error_t stream_peek(stream_t * stream, char_t *c) {
    return stream->peek(stream, c);
}

static inline error_t stream_poll(stream_t * stream, char_t *c) {
    return stream->poll(stream, c);
}

static inline source_info_t * stream_source_info(stream_t * stream) {
    return stream->source_info(stream);
}

source_info_t * file_stream_source_info(stream_t * stream);

#endif //EVO_CHAR_STREAM_H
