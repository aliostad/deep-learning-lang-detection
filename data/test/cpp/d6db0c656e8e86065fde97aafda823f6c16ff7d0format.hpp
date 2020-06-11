#ifndef SOUNDIO_FORMAT_H
#define SOUNDIO_FORMAT_H

#include <cstdlib>
#include <alsa/asoundlib.h>

enum sample_format
{
    SOUNDIO_SAMPLE_FORMAT_UNKNOWN,

    SOUNDIO_SAMPLE_FORMAT_U8,
    SOUNDIO_SAMPLE_FORMAT_S8,

    SOUNDIO_SAMPLE_FORMAT_U16,
    SOUNDIO_SAMPLE_FORMAT_S16,

    SOUNDIO_SAMPLE_FORMAT_U24,
    SOUNDIO_SAMPLE_FORMAT_S24,

    SOUNDIO_SAMPLE_FORMAT_U32,
    SOUNDIO_SAMPLE_FORMAT_S32
};

struct frame_format
{
    frame_format();
    frame_format(unsigned rate,             // e.g. 44100
                 unsigned channels,         // e.g. 2
                 sample_format sample_fmt); // e.g. SOUNDIO_SAMPLE_FORMAT_S16

    // sample_size * channels
    size_t frame_size() const;

    unsigned rate;
    unsigned channels;
    sample_format sample_fmt;
};

#endif
