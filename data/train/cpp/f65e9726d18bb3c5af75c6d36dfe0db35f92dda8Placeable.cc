#include "Placeable.h"




CHUNK chunk_NULL,chunk_C;

FreeChunk *FirstFCLib = NULL,*FirstFreeChunk_fore = NULL,*LastFreeChunk_fore = NULL,*FirstFreeChunk_back= NULL,
*LastFreeChunk_back = NULL ,*FirstFreeChunk_dynam = NULL,*LastFreeChunk_dynam = NULL ,*C_FreeChunk = NULL,
*NULL_FreeChunk = NULL,*FreeCTarget_Move = NULL ,*LastChunkFore= NULL ,*LastChunkBack = NULL,*LastChunkDynam= NULL;

DayNightChunk *FirstDNChunk = NULL ,*LastDNChunk= NULL,*CDNChunk= NULL;
DayNightTool DNTool[2],*CDNTool;

ColideChunk *FirstCOLChunk = NULL,*LastCOLChunk = NULL,*CCOLChunk = NULL;

ColideTool COLTool[2],*CCOLTool;
InterSpot *FirstItr,*LastItr;
NPCchunk *FirstNPCList,*LastNPCList,*FirstNPCMap,*LastNPCMap;
