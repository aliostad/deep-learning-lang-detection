
#ifndef __SVR_STREAM_H
#define __SVR_STREAM_H

#include <svr/forward.h>
#include <svr/lockable.h>
#include <svr/cv.h>

typedef enum {
    SVR_PAUSED,
    SVR_UNPAUSED
} SVR_StreamState;

struct SVR_Stream_s {
    char* stream_name;
    char* source_name;
    IplImage* current_frame;
    SVR_StreamState state;
    SVR_FrameProperties* frame_properties;
    SVR_Encoding* encoding;
    SVR_Decoder* decoder;
    bool orphaned;

    pthread_cond_t new_frame;
    SVR_LOCKABLE;
};

void SVR_Stream_init(void);
SVR_Stream* SVR_Stream_new(const char* source);
void SVR_Stream_destroy(SVR_Stream* stream);
int SVR_Stream_setEncoding(SVR_Stream* stream, const char* encoding);
int SVR_Stream_resize(SVR_Stream* stream, int width, int height);
int SVR_Stream_setGrayscale(SVR_Stream* stream, bool grayscale);
int SVR_Stream_setPriority(SVR_Stream* stream, short priority);
int SVR_Stream_setDropRate(SVR_Stream* stream, int drop_rate);
int SVR_Stream_unpause(SVR_Stream* stream);
int SVR_Stream_pause(SVR_Stream* stream);
SVR_FrameProperties* SVR_Stream_getFrameProperties(SVR_Stream* stream);
IplImage* SVR_Stream_getFrame(SVR_Stream* stream, bool wait);
void SVR_Stream_returnFrame(SVR_Stream* stream, IplImage* frame);
bool SVR_Stream_isOrphaned(SVR_Stream* stream);
void SVR_Stream_setOrphaned(const char* stream_name);
void SVR_Stream_sync(void);
void SVR_Stream_provideData(const char* stream_name, void* buffer, size_t n);

#endif // #ifndef __SVR_STREAM_H
