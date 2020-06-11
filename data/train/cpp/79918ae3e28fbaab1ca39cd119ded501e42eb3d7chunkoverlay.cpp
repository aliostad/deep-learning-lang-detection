#include "chunkoverlay.h"
#include "chunk.h"
#include "chunkoverlaymanager.h"

namespace Wanderlust
{
	chunkoverlay::chunkoverlay()
	{
		mOurChunk = 0;
		mManager = 0;
	}
	chunkoverlay::~chunkoverlay()
	{
		if(mManager)
		{
			mManager->NotifyOverlayUnloaded(this, mX, mY, mZ);
		}
	}
	void chunkoverlay::RegisterOurChunk(chunk* RegisterThis)
	{
		mOurChunk = RegisterThis;
	}
	void chunkoverlay::RegisterManager(chunkoverlaymanager*)
	{
	}
	chunkoverlaymanager* chunkoverlay::getManager()
	{
	}
	chunk* chunkoverlay::getOurChunk()
	{
		return mOurChunk;
	}
}