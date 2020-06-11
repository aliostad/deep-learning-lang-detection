
#ifndef __SVR_SERVER_STREAM_H
#define __SVR_SERVER_STREAM_H

#include <svr/forward.h>
#include <svrd/forward.h>

struct SVRD_Stream_s {
    char* name;

    SVRD_Client* client;
    SVRD_Source* source;

    SVR_Encoding* encoding;
    Dictionary* encoding_options;
    SVR_Encoder* encoder;
    SVR_FrameProperties* frame_properties;

    SVR_StreamState state;

    void* payload_buffer;
    size_t payload_buffer_size;

    int drop_rate;
    int drop_counter;

    short priority;

    IplImage* temp_frame[2];

    pthread_t worker;
    bool worker_started;

    SVR_LOCKABLE;
};

SVRD_Stream* SVRD_Stream_new(const char* name);
void SVRD_Stream_destroy(SVRD_Stream* stream);
void SVRD_Stream_setClient(SVRD_Stream* stream, SVRD_Client* client);
int SVRD_Stream_attachSource(SVRD_Stream* stream, SVRD_Source* source);
int SVRD_Stream_detachSource(SVRD_Stream* stream);
void SVRD_Stream_sourceClosing(SVRD_Stream* stream);
int SVRD_Stream_setEncoding(SVRD_Stream* stream, const char* encoding_descriptor);
int SVRD_Stream_setChannels(SVRD_Stream* stream, int channels);
int SVRD_Stream_setPriority(SVRD_Stream* stream, short priority);
int SVRD_Stream_setDropRate(SVRD_Stream* stream, int rate);
int SVRD_Stream_resize(SVRD_Stream* stream, int width, int height);

void SVRD_Stream_pause(SVRD_Stream* stream);
void SVRD_Stream_unpause(SVRD_Stream* stream);
void SVRD_Stream_inputSourceFrame(SVRD_Stream* stream, IplImage* frame);

#endif // #ifndef __SVR_SERVER_STREAM_H
