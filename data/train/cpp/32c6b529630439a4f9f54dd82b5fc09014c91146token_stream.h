#ifndef CC_TOKEN_STREAM_H
#define CC_TOKEN_STREAM_H

#include "token.h"

#define INIT_STREAM_LENGTH 8

typedef struct {
	token *tokens;
	int length;
} token_stream;

token_stream stream_create();
void stream_append(token_stream *stream, token tok);
void stream_cat(token_stream *stream, token_stream cat);

/* these don't allocate anything new */
token_stream stream_tail(token_stream stream, int start);
token_stream substream(token_stream stream, int start, int end);

int stream_identical(token_stream a, token_stream b);

#endif
