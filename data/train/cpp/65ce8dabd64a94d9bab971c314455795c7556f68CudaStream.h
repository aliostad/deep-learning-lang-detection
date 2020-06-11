#pragma once

#include "util.h"
#include "CudaEvent.h"

// wrapper around cuda streams
class CudaStream {
  public:
    CudaStream()
    : stream_(0) // use default stream
    {};

    // flag whether or not to create a new stream or use default stream
    CudaStream(bool create_new_stream) {
        stream_ = create_new_stream ? new_stream() : 0;
    }

    ~CudaStream() {
        if(stream_) {
            auto status = cudaStreamDestroy(stream_);
            cuda_check_status(status);
        }
    }

    // return the CUDA stream handle
    cudaStream_t stream() {
        return stream_;
    }

    // insert event into stream
    // returns immediately
    CudaEvent enqueue_event() {
        CudaEvent e;

        auto status = cudaEventRecord(e.event(), stream_);
        cuda_check_status(status);

        return e;
    }

    // make all future work on stream wait until event has completed.
    // returns immediately, not waiting for event to complete
    void wait_on_event(CudaEvent &e) {
        auto status = cudaStreamWaitEvent(stream_, e.event(), 0);
        cuda_check_status(status);
    }

  private:

    cudaStream_t new_stream() {
        cudaStream_t s;

        auto status = cudaStreamCreate(&s);
        cuda_check_status(status);

        return s;
    }

    cudaStream_t stream_;
};

