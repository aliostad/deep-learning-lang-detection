#include "DumpObject.h"
#include "../Dump.h"
#include "../Indexes/Index.h"
#include "../SpaceManager.h"

DumpObject::DumpObject(std::weak_ptr<Dump> dump)
    : dump(dump), savedOffset(0), savedLength(0)
{}

void DumpObject::Write()
{
    auto dumpRef = dump.lock();

    uint32_t newLength = NewLength();
    uint64_t newOffset;

    if (newLength == savedLength)
        newOffset = savedOffset;
    else
    {
        auto &spaceManager = dumpRef->spaceManager;

        if (savedOffset != 0)
            spaceManager->Delete(savedOffset, savedLength);

        newOffset = spaceManager->GetSpace(newLength);
    }

    stream = dumpRef->stream.get();
    stream->seekp(newOffset);

    WriteInternal();

#ifdef _DEBUG
    auto actualLength = (std::uint64_t)stream->tellp() - newOffset;

    if (actualLength > newLength)
        throw DumpException();
#endif

    stream = nullptr;

    bool overwriteIndex = savedOffset != 0;

    savedOffset = newOffset;
    savedLength = newLength;

    UpdateIndex(overwriteIndex);
}

void DumpObject::UpdateIndex(bool overwrite)
{}

uint64_t DumpObject::SavedOffset() const
{
    return savedOffset;
}
