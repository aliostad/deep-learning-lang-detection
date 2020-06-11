#ifndef RESOPHONIC_KAMASU_STREAM_HPP_INCLUDED
#define RESOPHONIC_KAMASU_STREAM_HPP_INCLUDED

#include <resophonic/kamasu/logging.hpp>
#include <boost/noncopyable.hpp>
#include <cuda_runtime.h>

namespace resophonic {
  namespace kamasu {

    struct stream_impl
    {
      cudaStream_t value;
      stream_impl() { value = 0; }
    };

    struct stream : boost::noncopyable, stream_impl
    { 
      stream()
      {
	cudaStreamCreate(&value);
	log_trace("Created stream %d", value);
      }

      ~stream()
      {
	log_trace("Destroying stream %d", value);
	cudaStreamSynchronize(value);
	cudaStreamDestroy(value);
      }


    private:
      stream(const stream&);
    };

  }
}



#endif
