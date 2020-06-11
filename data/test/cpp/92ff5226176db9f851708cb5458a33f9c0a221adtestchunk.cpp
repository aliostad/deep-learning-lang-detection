#include "ChunkManager.h"
#include "../netlib/base/Logging.h"
#include <stdio.h>

using namespace myfs;
using mynet::Logger;
int main()
{
	ChunkManager chunkManager("/fstest", 50);
	chunkManager.addChunk("1");
	chunkManager.addChunk("2");
	chunkManager.addChunk("3");
	chunkManager.delChunk("3");
	

	chunkManager.addChunk("4");
	chunkManager.addChunk("5");

	string str = "1234567890";
	chunkManager.writeChunk("5", 0, str);

	int i;
	scanf("%d", &i);
	string readstr = chunkManager.readChunk("5", 0, 10);

	LOG_INFO << readstr;

	return 0;
}

