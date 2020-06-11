// ChunkBufferPool.cpp

//********************************************************************

#ifndef jlj_nio_reactor_ChunkBufferPool_cpp
#define jlj_nio_reactor_ChunkBufferPool_cpp

//********************************************************************

#include <jlj/nio/reactor/ChunkBufferPool.h>
#include <jlj/nio/reactor/Multiplexer.h>
#include <jlj/util/concurrent/LinkedBlockingQueue.h>
using namespace jlj::util::concurrent;

//********************************************************************

NAMESPACE_BEGIN(jlj)
NAMESPACE_BEGIN(nio)
NAMESPACE_BEGIN(reactor)

//********************************************************************

const int ChunkBufferPoolI::DEFAULTCAPACITY = (35*1460) + Multiplexer::IDENTIFIERLENGTH; // 51100+32

//********************************************************************

ChunkBufferPoolI::~ChunkBufferPoolI() 
{
	logger->log(Level::FINEST, L"ChunkBufferPoolI::~ChunkBufferPoolI()");
	while (0 < idle->size())
	{
		ChunkBuffer chunk = idle->poll();
		destroyBuffer(chunk);
	}
}

//********************************************************************

ChunkBufferPoolI::ChunkBufferPoolI()
: initialsize(0)
, maxsize(20000)
, inuse(0)
, idle(new LinkedBlockingQueueI<ChunkBuffer>())
, logger(Logger::getLogger(Reactor::REACTORS_LOGGER_NAME))
{
	for (int i = 0; i < initialsize; ++i)
	{
		idle->put(createBuffer(DEFAULTCAPACITY));
	}
}

//********************************************************************

ChunkBuffer ChunkBufferPoolI::createBuffer(int capacity)
{
	ChunkBuffer chunk = new ChunkBufferI();
	chunk->capacity = capacity;
	chunk->position = 0;
	chunk->limit = capacity;
	chunk->buffer = new char[capacity];
	return chunk;
}

//********************************************************************

void ChunkBufferPoolI::destroyBuffer(ChunkBuffer chunk)
{
	delete [] chunk->buffer;
	delete chunk;
}

//********************************************************************

void ChunkBufferPoolI::clearBuffer(ChunkBuffer chunk)
{
	if (0 != chunk)
	{
		chunk->position = 0;
		chunk->limit = chunk->capacity;
	}
}

//********************************************************************

ChunkBuffer ChunkBufferPoolI::get() throw (InterruptedException)
{
	ChunkBuffer chunk = 0;
	try
	{
		chunk = idle->remove();
	}
	catch (const NoSuchElementException&)
	{}
	if (0 == chunk)
	{
		if (maxsize > inuse)
		{
			logger->log(Level::WARNING, L"ChunkBufferPool : " + String(idle->size() + inuse) + L", idle : " + String(idle->size()) + L", inuse : " + String(inuse->get()));
			chunk = createBuffer(DEFAULTCAPACITY);
		}
		else
		{
			logger->log(Level::SEVERE, L"ChunkBufferPool exhausted : " + String(maxsize));
			chunk = idle->take(); 
		}
	}
	++inuse;

#if 0
	if (logger->isLoggable(Level::FINEST))
	{
		logger->log(Level::FINEST, L"ChunkBufferPool get : " + String(idle->size()) + L", inuse : " + String(inuse->get()));
	}
#endif

	return chunk;
}

//********************************************************************

void ChunkBufferPoolI::makeIdle(ChunkBuffer& chunk) 
{
	if (0 != chunk)
	{
		clearBuffer(chunk);
		idle->put(chunk);
		--inuse;

		chunk = 0;

#if 0
		if (logger->isLoggable(Level::FINEST))
		{
			logger->log(Level::FINEST, L"ChunkBufferPool idle : " + String(idle->size()) + L", inuse : " + String(inuse->get()));
		}
#endif

		int i = idle->size();
		if (maxsize/2 < i && i < maxsize)
		{
			while (idle->size() > initialsize)
			{
				ChunkBuffer chunk = idle->poll();
				if (0 == chunk) break;
				destroyBuffer(chunk);
			}
		}
	}
}

//********************************************************************

int ChunkBufferPoolI::idles() const
{
	return idle->size();
}

//********************************************************************

int ChunkBufferPoolI::inUse() const
{
	return inuse;
}

//********************************************************************

NAMESPACE_END(reactor)
NAMESPACE_END(nio)
NAMESPACE_END(jlj)

//********************************************************************

#endif

// eof
