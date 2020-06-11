#ifndef __STECAMFRAMEDUMPER_INL__
#define __STECAMFRAMEDUMPER_INL__

inline void CFrameDump::process(void* pBuffer, int aLength, TDumpReplayType aDumpType) {
#ifdef CAM_DUMP_REPLAY_FRAME_BUFFERS
    dumpBuffer(pBuffer, aLength, aDumpType);
#endif
}

inline void CFrameDump::process(void* pBuffer, TDumpReplayType aDumpType) {
#ifdef CAM_DUMP_REPLAY_FRAME_BUFFERS
    dumpBuffer(pBuffer, aDumpType);
#endif
}

inline bool CFrameDump::start(TDumpReplayType aDumpType, int aWidth, int aHeight, TColorFmt aColorFormat,
                              STECamera* aCamerHal, int aAllocLen, MMHwBuffer* aMMHwBuffer) {
#ifdef CAM_DUMP_REPLAY_FRAME_BUFFERS
    return startDump(aDumpType, aWidth, aHeight, aColorFormat, aCamerHal, aAllocLen, aMMHwBuffer);
#endif
}

inline void CFrameDump::stop(TDumpReplayType aDumpType) {
#ifdef CAM_DUMP_REPLAY_FRAME_BUFFERS
    stopDump(aDumpType);
#endif
}
#endif //__STECAMFRAMEDUMPER_INL__
