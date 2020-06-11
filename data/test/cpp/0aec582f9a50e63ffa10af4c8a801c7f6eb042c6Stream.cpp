#include "Stream.hpp"

namespace std {

	static void _runSerialize(IStream * nStream, ISerialize * nSerialize)
	{
		Stream * stream = reinterpret_cast<Stream *>(nStream->mStream);
		stream->_serialize(nSerialize);
	}

	static void _uninitialized(IStream * nStream)
	{
		Stream * stream = reinterpret_cast<Stream *>(nStream->mStream);
		checked_delete(stream);
		stream = __nptr;
	}

	IStream * Stream::_getSteam()
	{
		return (&mStream);
	}

	Stream::Stream()
	{
		mStream.mStream = reinterpret_cast<void *>(this);
		mStream.mRunSerialize = std::_runSerialize;
		mStream.mUninitialized = std::_uninitialized;
	}

	Stream::~Stream()
	{
		mStream.mStream = __nptr;
		mStream.mRunSerialize = __nptr;
		mStream.mUninitialized = __nptr;
	}

}
