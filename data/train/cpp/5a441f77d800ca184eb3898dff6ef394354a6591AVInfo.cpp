#include "debug.hpp"
#include "AVInfo.hpp"

AVInfo::AVInfo
    (
    double aFps /* = 0.0 */,
    double aUsecs /* = 0.0 */,
    unsigned aAudioChannel /* = 0.0 */,
    AVSampleFormat aSampleFormat /* = AV_SAMPLE_FMT_NONE */,
    unsigned aAudioSampleRate /* = 0.0 */,
    unsigned aAudioBitsPerSample /* = 0.0 */
    )
{
    mFps = aFps;
    mUsecs = aUsecs;
    mAudioChannel = aAudioChannel;
    mAudioSampleFormat = turnLibavSampleFormat( aSampleFormat );
    mAudioSampleRate = aAudioSampleRate;
    mAudioBitsPerSample = aAudioBitsPerSample;

    dump();
}

AudioPlayer::SampleFormat AVInfo::turnLibavSampleFormat( AVSampleFormat aFormat )
{
    DEBUG() << "get a audio sample format: " << av_get_sample_fmt_name(aFormat);
    /*
        not support libav sample format:
        AV_SAMPLE_FMT_U8P,
        AV_SAMPLE_FMT_S16P,
        AV_SAMPLE_FMT_S32P,
        AV_SAMPLE_FMT_FLTP,
        AV_SAMPLE_FMT_DBLP,
        AV_SAMPLE_FMT_DBL,
        AV_SAMPLE_FMT_NONE,
        AV_SAMPLE_FMT_NB

        enum AVSampleFormat {
            AV_SAMPLE_FMT_NONE = -1,
            AV_SAMPLE_FMT_U8,          ///< unsigned 8 bits
            AV_SAMPLE_FMT_S16,         ///< signed 16 bits
            AV_SAMPLE_FMT_S32,         ///< signed 32 bits
            AV_SAMPLE_FMT_FLT,         ///< float
            AV_SAMPLE_FMT_DBL,         ///< double

            AV_SAMPLE_FMT_U8P,         ///< unsigned 8 bits, planar
            AV_SAMPLE_FMT_S16P,        ///< signed 16 bits, planar
            AV_SAMPLE_FMT_S32P,        ///< signed 32 bits, planar
            AV_SAMPLE_FMT_FLTP,        ///< float, planar
            AV_SAMPLE_FMT_DBLP,        ///< double, planar

            AV_SAMPLE_FMT_NB           ///< Number of sample formats. DO NOT USE if linking dynamically
        };
    */
    switch ( aFormat )
    {
        case AV_SAMPLE_FMT_U8:
        case AV_SAMPLE_FMT_U8P: return AudioPlayer::UInt8;

        case AV_SAMPLE_FMT_S16:
        case AV_SAMPLE_FMT_S16P:return AudioPlayer::Int16;

        case AV_SAMPLE_FMT_S32:
        case AV_SAMPLE_FMT_S32P:return AudioPlayer::Int32;

        case AV_SAMPLE_FMT_FLT:
        case AV_SAMPLE_FMT_FLTP:return AudioPlayer::Float32;

        default:                return AudioPlayer::Error;
    }
}

double AVInfo::getFps() const
{
    return mFps;
}

double AVInfo::getUsecs() const
{
    return mUsecs;
}

unsigned AVInfo::getAudioChannel() const
{
    return mAudioChannel;
}

AudioPlayer::SampleFormat AVInfo::getAudioSampleFormat() const
{
    return mAudioSampleFormat;
}

unsigned AVInfo::getAudioSampleRate() const
{
    return mAudioSampleRate;
}

unsigned AVInfo::getAudioBitsPerSample() const
{
    return mAudioBitsPerSample;
}

void AVInfo::dump() const
{
    DEBUG() << "fps:" << mFps;
    DEBUG() << "audio channel:" << mAudioChannel;
    DEBUG() << "audio sample rate:" << mAudioSampleRate;
    DEBUG() << "audio sample format:" << mAudioSampleFormat;
    DEBUG() << "audio bits per sample:" << mAudioBitsPerSample;
    DEBUG() << "av length:" << mUsecs / 1000000.0;
}
