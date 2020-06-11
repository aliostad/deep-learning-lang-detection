#include "ChunkInfo.h"
#include <assert.h>

using namespace myfs;

ChunkServerAddr::ChunkServerAddr(string name, string ipAddr, int port)
 :  name_(name),
	ipAddr_(ipAddr),
	port_(port)
{
}


bool myfs::operator==(const ChunkServerAddr& ls, const ChunkServerAddr& rs) 
{
	return (ls.ipAddr() == rs.ipAddr()) && (ls.port() == rs.port());
}

string ChunkServerAddr::name() const
{
	return name_;
}

string ChunkServerAddr::ipAddr() const
{
	return ipAddr_;
}

int ChunkServerAddr::port() const
{
	return port_;
}

ChunkInfo::ChunkInfo(string chunkName, int ncopy)
 :  chunkName_(chunkName),
	chunkSize_(0),
	ncopy_(ncopy)
{
}

string ChunkInfo::chunkName()
{
	return chunkName_;
}

int ChunkInfo::chunkSize()
{
	return chunkSize_;
}

void ChunkInfo::setChunkSize(int chunkSize)
{
	chunkSize_ = chunkSize;
}

int ChunkInfo::ncopy()
{
	return ncopy_;
}

void ChunkInfo::setNcopy(int ncopy)
{
	ncopy_ = ncopy;
}

vector<ChunkServerAddr>& ChunkInfo::chunkAddrs()
{
	return chunkAddrs_;
}

void ChunkInfo::setChunkAddr(int index, const ChunkServerAddr& chunkAddr)
{
	assert((index >= 0) && (index <= chunkAddrs_.size()));

	/* 
	 * if index == size, append a new chunkaddr
	 * else set a chunkaddr
	 */
	if (index < chunkAddrs_.size()) {
		chunkAddrs_[index] = chunkAddr;
	} else {
		chunkAddrs_.push_back(chunkAddr);
	}
}
