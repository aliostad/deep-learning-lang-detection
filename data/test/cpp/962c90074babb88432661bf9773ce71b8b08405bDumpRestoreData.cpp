#include "torc/generic/om/DumpRestoreData.hpp"

#ifdef GENOM_SERIALIZATION
namespace torc {
namespace generic {

DumpRestoreData::DumpRestoreData(
            const std::string &inDumpPath,
            ObjectFactorySharedPtr inFactory,
            bool inRestoreAllComponents  )
    :mDumpPath( inDumpPath ),
    mFactory( inFactory ),
    mRestoreAllComponents( inRestoreAllComponents ) {
}

DumpRestoreData::DumpRestoreData( const DumpRestoreData &inRhs )
    :mDumpPath( inRhs.mDumpPath ),
    mFactory( inRhs.mFactory ),
    mRestoreAllComponents( inRhs.mRestoreAllComponents ) {
}

DumpRestoreData::~DumpRestoreData() throw() {
}

DumpRestoreData &
DumpRestoreData::operator = ( const DumpRestoreData &inRhs ) {
    if( this != &inRhs )
    {
        mDumpPath = inRhs.mDumpPath;
        mFactory = inRhs.mFactory;
        mRestoreAllComponents = inRhs.mRestoreAllComponents;
    }
    return *this;
}

} // namespace torc
} // namespace generic

#endif //GENOM_SERIALIZATION
