#include "cwtfilter.h"
#include "cwtchunk.h"
#include "cwt.h"

#include <boost/foreach.hpp>

using namespace Signal;

namespace Tfr {

void CwtChunkFilter::
        operator()( ChunkAndInverse& c )
{
    Tfr::CwtChunk* cwtchunk = dynamic_cast<Tfr::CwtChunk*>(c.chunk.get ());
    BOOST_FOREACH(pChunk chunk, cwtchunk->chunks) {
        Tfr::ChunkAndInverse c2 = c;
        c2.chunk = chunk;

        subchunk(c2);
    }
}


CwtChunkFilterDesc::
        CwtChunkFilterDesc()
{
    Cwt* desc;
    Tfr::pTransformDesc t(desc = new Cwt);
    transformDesc( t );
}


void CwtChunkFilterDesc::
        transformDesc( Tfr::pTransformDesc m )
{
    const Cwt* desc = dynamic_cast<const Cwt*>(m.get ());

    EXCEPTION_ASSERT(desc);

    ChunkFilterDesc::transformDesc (m);
}

} // namespace Tfr
