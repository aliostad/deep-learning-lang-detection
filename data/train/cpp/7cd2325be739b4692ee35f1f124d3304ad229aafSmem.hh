// should contain smem dirty details.

#include <boost/utility.hpp>
#include "Stream.hh"

namespace encre
{
  class Smem : boost::noncopyable
  {
  private :
    Stream*		outputStream;
  public :
    void		setVideoLockCallback(Stream* stream, void* callback);
    void		setVideoUnlockCallback(Stream* stream, void* callback);
    void		setDataLockCallback(Stream* stream, void* callback);
    void		setDataUnlockCallback(Stream* stream, void* callback);
    void		setAudioLockCallback(Stream* stream, void* callback);
    void		setAudioUnlockCallback(Stream* stream, void* callback);
    void		setVideoDataCtx(Stream* stream, void* dataCtx);
    void		setDataCtx(Stream* stream, void* dataCtx);
    void		setSmem(Stream*, const std::string&, const std::string&, void*);
  };
}
