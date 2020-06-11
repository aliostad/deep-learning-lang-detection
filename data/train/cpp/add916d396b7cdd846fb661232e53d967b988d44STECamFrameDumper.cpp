#include <sys/stat.h>
#include <OMX_IVCommon.h>
#include <OMX_Symbian_IVCommonExt_Ste.h>

#undef CAM_LOG_TAG
#define CAM_LOG_TAG DBGT_TAG
#define DBGT_LAYER 2
#define DBGT_PREFIX "Dump  "

#include "STECamTrace.h"

#include "STECamFrameDumper.h"
#include "STECamera.h"

namespace android {

CFrameDump::CFrameDump() {
    DBGT_PROLOG("");

    mDumpReplay[EPreview].mKey = DynSetting::EPreviewDump;
    mDumpReplay[EPreview].mPrefix = kPreviewFilePfx;
    mDumpReplay[ERecording].mKey = DynSetting::ERecordingDump;
    mDumpReplay[ERecording].mPrefix = kRecordingFilePfx;

    DBGT_EPILOG("");
    return;
}

CFrameDump::~CFrameDump() {
    DBGT_PROLOG("");

    DBGT_EPILOG("");
    return;
}

void CFrameDump::getNextFileName(TDumpReplayType aDumpType, const char* aLocation) {
    DBGT_PROLOG("aDumpType: %d, aLocation: %s",aDumpType,aLocation);

    DBGT_ASSERT(aDumpType<EMaxDumpReplay,"invalid Dump Request");

    if (aLocation) {
        snprintf(mDumpReplay[aDumpType].mFilename,FILENAME_MAX,"%s",(char*)aLocation);
    } else {
        // open the preview/record dump file with default path
        mkdir(kFileLocationBase, 777);
        snprintf(mDumpReplay[aDumpType].mFilename,FILENAME_MAX,"%s%s_%d_%d_%s",
                kFileLocationBase,mDumpReplay[aDumpType].mPrefix,
                mDumpReplay[aDumpType].mWidth,mDumpReplay[aDumpType].mHeight,
                g_ColorFmtInfo[mDumpReplay[aDumpType].mColorFormat].mColorFmtExtStr);
    }

    DBGT_PTRACE("dumpFilename: %s",mDumpReplay[aDumpType].mFilename);

    DBGT_EPILOG("");
    return;
}

void CFrameDump::dumpBuffer(void* pBuffer, int aLength, TDumpReplayType aDumpType) {
    if(mDumpReplay[aDumpType].mContinue) {
        DBGT_PROLOG("aDumpType: %d, buffer: 0x%p, length: %d",aDumpType, pBuffer, aLength);

        DBGT_ASSERT(NULL != pBuffer, "pBuffer is NULL");
        DBGT_ASSERT(0 != aLength, "aLength is zero");
        DBGT_ASSERT(aDumpType<EMaxDumpReplay,"invalid Dump Request");

        if(mDumpReplay[aDumpType].mCameraHal && (mDumpReplay[aDumpType].mBufferAllocLen > 0)) {
            OMX_ERRORTYPE omxerr = mDumpReplay[aDumpType].mCameraHal->synchCBData(MMHwBuffer::ESyncAfterWriteHwOperation,
                                                                                  *mDumpReplay[aDumpType].mMMHwBuffer,
                                                                                  (OMX_U8*)pBuffer, mDumpReplay[aDumpType].mBufferAllocLen);
            DBGT_PTRACE("omxerr : %d",omxerr);
        }

        int bytesWritten = fwrite(pBuffer,1,aLength,mDumpReplay[aDumpType].mFile);
        if(bytesWritten < aLength) {
            DBGT_CRITICAL("Error dumping frames. Check space available on sdcard/device");
        }

        DBGT_EPILOG();
        return;
    }
}

void CFrameDump::dumpBuffer(void* pBuffer, TDumpReplayType aDumpType) {
    dumpBuffer(pBuffer,
               (mDumpReplay[aDumpType].mWidth*mDumpReplay[aDumpType].mHeight*g_ColorFmtInfo[mDumpReplay[aDumpType].mColorFormat].mBpp/8),
               aDumpType);
}

bool CFrameDump::startDump(TDumpReplayType aDumpType, int aWidth, int aHeight, TColorFmt aColorFormat,
                           STECamera* aCameraHal, int aAllocLen, MMHwBuffer* aMMHwBuffer) {
    DBGT_PROLOG("");

    DBGT_PTRACE("aDumpType: %d, aWidth: %d, aHeight: %d",aDumpType, aWidth, aHeight);
    DBGT_PTRACE("aColorFormat: %#x, aCameraHal: %p, aAllocLen: %d",aColorFormat, aCameraHal, aAllocLen);

    DBGT_ASSERT(aDumpType<EMaxDumpReplay,"invalid Dump Request");
    DBGT_ASSERT(0 != aWidth, "aWidth is zero");
    DBGT_ASSERT(0 != aHeight, "aHeight is zero");
    DBGT_ASSERT(aColorFormat<EMaxColorFmt,"invalid Color Format");

    mDumpReplay[aDumpType].resetData();
    mDumpReplay[aDumpType].setData(aWidth, aHeight, aColorFormat,aCameraHal,aAllocLen,aMMHwBuffer);

    char key[FILENAME_MAX + 1];
    DynSetting::get(mDumpReplay[aDumpType].mKey, key);
    DBGT_PTRACE("key: %s",key);

    if((!strcmp(key,"0")) || (!strcmp(key,""))) {
        mDumpReplay[aDumpType].resetData();

        DBGT_PTRACE("Key not set, not dumping");
        DBGT_EPILOG("");
        return false;
    }

    if (!strcmp(key,"1")) {
        getNextFileName(aDumpType,NULL);
    } else {
        getNextFileName(aDumpType,key);
    }

    mDumpReplay[aDumpType].mFile = fopen(mDumpReplay[aDumpType].mFilename,"wb");
    if(!mDumpReplay[aDumpType].mFile) {
        mDumpReplay[aDumpType].resetData();

        DBGT_PTRACE("Can't open file, not dumping");
        DBGT_EPILOG("");
        return false;
    }

    mDumpReplay[aDumpType].mContinue = true;

    DBGT_PTRACE("dumping");
    DBGT_EPILOG("");
    return true;
}

void CFrameDump::stopDump(TDumpReplayType aDumpType) {
    DBGT_PROLOG("");

    DBGT_ASSERT(aDumpType<EMaxDumpReplay,"invalid Dump Request");

    mDumpReplay[aDumpType].resetData();

    DBGT_EPILOG("");
    return;
}

};
