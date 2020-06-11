// This file was generated based on 'C:\ProgramData\Uno\Packages\Fuse.Video\0.24.7\Graphics\$.uno'.
// WARNING: Changes might be lost if you edit this file directly.

#pragma once
#include <Uno.Object.h>
namespace g{namespace Fuse{namespace Video{struct LoadResult;}}}

namespace g{
namespace Fuse{
namespace Video{

// internal abstract class LoadResult :525
// {
uType* LoadResult_typeof();
void LoadResult__ctor__fn(LoadResult* __this);
void LoadResult__Failed_fn(LoadResult* result, bool* __retval);
void LoadResult__GetErrorMessage_fn(LoadResult* result, uString** __retval);
void LoadResult__GetPlayer_fn(LoadResult* result, uObject** __retval);
void LoadResult__Succeded_fn(LoadResult* result, bool* __retval);

struct LoadResult : uObject
{
    void ctor_();
    static bool Failed(LoadResult* result);
    static uString* GetErrorMessage(LoadResult* result);
    static uObject* GetPlayer(LoadResult* result);
    static bool Succeded(LoadResult* result);
};
// }

}}} // ::g::Fuse::Video
