#include "ridge.h"
#include "tfr/chunk.h"

#include <complex>
#include <vector>
#include <string.h>

namespace Filters
{

void Ridge::
        subchunk( Tfr::ChunkAndInverse& chunkai )
{
    Tfr::Chunk& chunk = *chunkai.chunk;
    Tfr::ChunkElement* p     = chunk.transform_data->getCpuMemory();

    std::vector<Tfr::ChunkElement> q[] = {
        std::vector<Tfr::ChunkElement>(chunk.nSamples()),
        std::vector<Tfr::ChunkElement>(chunk.nSamples())
    };

    unsigned bytes_per_row = sizeof(Tfr::ChunkElement)*chunk.nSamples();

    Tfr::ChunkElement
            *prev_row = &q[0][0],
            *this_row = &q[1][0];

    for (unsigned y=1; y<chunk.nScales()-1; y++)
    {
        Tfr::ChunkElement* t = prev_row;
        prev_row = this_row;
        this_row = t;

        for (unsigned x=0; x<chunk.nSamples(); x++)
        {
            Tfr::ChunkElement a = p[(y-1)*chunk.nSamples() + x];
            Tfr::ChunkElement b = p[(y+0)*chunk.nSamples() + x];
            Tfr::ChunkElement c = p[(y+1)*chunk.nSamples() + x];
            float A = norm(a);
            float B = norm(b);
            float C = norm(c);
            this_row[x] = (B > A  &&  B > C) ? b : Tfr::ChunkElement(0, 0);
        }

        if (1<y)
            memcpy( p + (y-1)*chunk.nSamples(), prev_row, bytes_per_row );
    }
    memcpy( p + (chunk.nScales()-2)*chunk.nSamples(),
            this_row,
            bytes_per_row );
    memset( p + (chunk.nScales()-1)*chunk.nSamples(), 0, bytes_per_row );
    memset( p                                         , 0, bytes_per_row );
}


Tfr::pChunkFilter RidgeDesc::
        createChunkFilter(Signal::ComputingEngine*) const
{
    return Tfr::pChunkFilter(new Ridge);
}


Tfr::ChunkFilterDesc::ptr RidgeDesc::
        copy() const
{
    return Tfr::ChunkFilterDesc::ptr(new RidgeDesc);
}

} // namespace Filters
