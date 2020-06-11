#include "cir/common/concurrency/StreamHandler.h"

namespace cir { namespace common { namespace concurrency {

std::map<boost::thread::id, cv::gpu::Stream*> StreamHandler::_threadToStreamMap;

StreamHandler::StreamHandler() {

}

StreamHandler::~StreamHandler() {

}

cv::gpu::Stream* StreamHandler::currentStream() {
	boost::thread::id threadId = boost::this_thread::get_id();
	std::map<boost::thread::id, cv::gpu::Stream*>::iterator it = _threadToStreamMap.find(threadId);
	if(it == _threadToStreamMap.end()) {
		cv::gpu::Stream* stream = new cv::gpu::Stream;
		_threadToStreamMap[threadId] = stream;
		return stream;
	} else {
		return (*it).second;
	}
}

cudaStream_t StreamHandler::nativeStream() {
	cv::gpu::Stream* currentStream = StreamHandler::currentStream();
	return cv::gpu::StreamAccessor::getStream(*currentStream);
}

void StreamHandler::waitForCompletion() {
	for(std::map<boost::thread::id, cv::gpu::Stream*>::iterator it = _threadToStreamMap.begin();
			it != _threadToStreamMap.end(); it++) {
		cv::gpu::Stream* stream = (*it).second;
		stream->waitForCompletion();
	}
}

}}}
