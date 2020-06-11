#ifndef _V3D_STREAM_MANAGER_H_
#define _V3D_STREAM_MANAGER_H_

#include "FileStream.h"
#include "MemoryStream.h"

namespace v3d
{
namespace stream
{
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    class CStreamManager
    {
    public:

        static FileStreamPtr    createFileStream(const std::string& file, FileStream::EOpenMode mode = FileStream::e_in);
        static MemoryStreamPtr  createMemoryStream(const void* data = nullptr, const u32 size = 0);

    };

    /////////////////////////////////////////////////////////////////////////////////////////////////////
}
}

#endif //_V3D_STREAM_MANAGER_H_
