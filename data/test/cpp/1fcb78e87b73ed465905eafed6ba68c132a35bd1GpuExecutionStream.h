#ifndef __GPUEXECUTIONSTREAM_H
#define __GPUEXECUTIONSTREAM_H
#pragma once

//#include "CudaDebug.h"
#include <cuda_runtime_api.h>
#include "cuda.h"
#include "helper_cuda.h"
#include <stdexcept>

// A very simple wrapper around the cudaStream_t type
class GpuExecutionStream
{
private:
	cudaStream_t stream;

public:
	GpuExecutionStream(bool createNull)
	{
		if(createNull)
			stream = (cudaStream_t)0;
		else
			cudaStreamCreate(&stream);
	}
	GpuExecutionStream(const GpuExecutionStream & rhs)
	{
        throw std::runtime_error("Cannot copy execution stream instances");
	}
	~GpuExecutionStream()
	{
		if(stream != 0)
			cudaStreamDestroy(stream);
		stream = 0;
	}

	void Synchronize() const
	{
		// This does not work ..?
		//CUDA_CALL(cudaStreamSynchronize(stream)); 
        checkCudaErrors( cudaThreadSynchronize() );
	}

	cudaStream_t Get() const { return stream; }
};

#endif // __GPUEXECUTIONSTREAM_H
