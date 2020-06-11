#ifdef USE_CUDA
#include "move.h"
#include "move.cu.h"
#include "tfr/chunk.h"

//#define TIME_FILTER
#define TIME_FILTER if(0)

using namespace Tfr;

namespace Filters {

Move::
        Move(float df)
:   _df(df)
{}

void Move::
        operator()( Tfr::ChunkAndInverse& chunk )
{
    Tfr::Chunk& chunk = *chunkai.chunk;
    TIME_FILTER TaskTimer tt("Move");

    float df = _df * chunk.nScales();

    ::moveFilter( chunk.transform_data,
                  df, chunk.minHz(), chunk.maxHz(), chunk.sample_rate, chunk.chunk_offset.asInteger() );
}

} // namespace Filters
#else
int USE_CUDA_Move;
#endif
