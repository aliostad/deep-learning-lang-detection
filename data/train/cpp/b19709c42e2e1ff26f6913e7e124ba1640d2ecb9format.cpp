#include "format.hpp"

namespace
{
   size_t sample_size(sample_format format)
   {
      switch (format)
      {
      case SOUNDIO_SAMPLE_FORMAT_U8:
      case SOUNDIO_SAMPLE_FORMAT_S8:
         return 1;
      case SOUNDIO_SAMPLE_FORMAT_U16:
      case SOUNDIO_SAMPLE_FORMAT_S16:
         return 2;
      case SOUNDIO_SAMPLE_FORMAT_U24:
      case SOUNDIO_SAMPLE_FORMAT_S24:
         return 3;
      case SOUNDIO_SAMPLE_FORMAT_U32:
      case SOUNDIO_SAMPLE_FORMAT_S32:
         return 4;
      default:
         assert(false);
      }
   }
}

frame_format::frame_format()
   : rate()
   , channels()
   , sample_fmt(SOUNDIO_SAMPLE_FORMAT_UNKNOWN)
{}

frame_format::frame_format(unsigned sample_rate, unsigned channels, sample_format sample_fmt)
   : rate(sample_rate)
   , channels(channels)
   , sample_fmt(sample_fmt)
{}

size_t frame_format::frame_size() const
{
   return sample_size(sample_fmt) * channels;
}
