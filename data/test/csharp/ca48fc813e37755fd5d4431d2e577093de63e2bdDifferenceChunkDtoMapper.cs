using Server.Core;
using Server.Service.Dtos;

namespace Server.Service.Mappers
{
    public static class DifferenceChunkDtoMapper
    {
        public static DifferenceChunkDto Map(DifferenceChunk differenceChunk)
        {
            return new DifferenceChunkDto
            {
                ChunkInformation = differenceChunk.ChunkInformation,
                CachedFileChunkNumber = differenceChunk.CachedFileChunkNumber,
                CurentFileChunkNumber = differenceChunk.CurentFileChunkNumber
            };
        }
    }
}