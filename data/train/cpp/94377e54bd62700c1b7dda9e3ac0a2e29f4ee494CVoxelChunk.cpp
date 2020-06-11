#include "CVoxelChunk.hpp"

CVoxelChunk::CVoxelChunk() {
	chunkLocation.iX = 0;
	chunkLocation.iY = 0;
	chunkLocation.iZ = 0;

	voxelList = (unsigned char *)calloc(CHUNK_XSIZE*CHUNK_YSIZE*CHUNK_ZSIZE, sizeof(unsigned char));
}

CVoxelChunk::CVoxelChunk(int iX, int iY, int iZ) {
	chunkLocation.iX = iX;
	chunkLocation.iY = iY;
	chunkLocation.iZ = iZ;

	voxelList = (unsigned char *)calloc(CHUNK_XSIZE*CHUNK_YSIZE*CHUNK_ZSIZE, sizeof(unsigned char));
}

void CVoxelChunk::setChunkLocation(int iX, int iY, int iZ) {
	chunkLocation.iX = iX;
	chunkLocation.iY = iY;
	chunkLocation.iZ = iZ;
}

unsigned char CVoxelChunk::getVoxel(int iX, int iY, int iZ) {
	int index = iX + iY*CHUNK_XSIZE + iZ*CHUNK_XSIZE*CHUNK_YSIZE;
	if (index >= 0 && index < CHUNK_VOXELCOUNT) {
		return voxelList[index];
	}
	return 0;
}

unsigned char CVoxelChunk::getVoxel(SLocation voxelLocation) {
	int index = voxelLocation.iX + voxelLocation.iY*CHUNK_XSIZE + voxelLocation.iZ*CHUNK_XSIZE*CHUNK_YSIZE;
	if (index >= 0 && index < CHUNK_VOXELCOUNT) {
		return voxelList[index];
	}
	return 0;
}

void CVoxelChunk::setVoxel(int iX, int iY, int iZ, int iType) {
	int index = iX + iY*CHUNK_XSIZE + iZ*CHUNK_XSIZE*CHUNK_YSIZE;
	int oldType;
	if (index >= 0 && index < CHUNK_VOXELCOUNT) {
		oldType = voxelList[index];
		if (oldType != iType) {
			voxelList[index] = iType;
			iEditCount++;
			if (!iType) {
				iVoxelCount--;
			}
			else if (!oldType) {
				iVoxelCount++;
			}
		}
	}
}

void CVoxelChunk::setVoxel(SLocation voxelLocation, int iType) {
	int index = voxelLocation.iX + voxelLocation.iY*CHUNK_XSIZE + voxelLocation.iZ*CHUNK_XSIZE*CHUNK_YSIZE;
	int oldType;
	if (index >= 0 && index < CHUNK_VOXELCOUNT) {
		oldType = voxelList[index];
		if (oldType != iType) {
			voxelList[index] = iType;
			iEditCount++;
			if (!iType) {
				iVoxelCount--;
			}
			else if (!oldType) {
				iVoxelCount++;
			}
		}
	}
}