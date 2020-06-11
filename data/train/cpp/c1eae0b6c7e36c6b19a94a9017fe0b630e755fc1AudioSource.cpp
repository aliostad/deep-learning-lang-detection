#include "nooraudio.h"

namespace nooraudio {

  //-- AudioSource class ------------------------------------------------------

  void AudioSource::resolveSampleSize( SampleSize sampleSize )
  {
    mSampleSize = sampleSize;
    switch ( mSampleSize ) {
      case SampleSize_8bit:
        mSampleBits = 8;
        mSampleBytes = 1;
      break;
      case SampleSize_16bit:
        mSampleBits = 16;
        mSampleBytes = 2;
      break;
      default:
        throw std::exception( "Unsupported sample size" );
      break;
    }
  }

  AudioSource::AudioSource( const std::wstring& fileName,
  SampleSize sampleSize ): mFile( NULL )
  {
    resolveSampleSize( sampleSize );
    if ( _wfopen_s( &mFile, fileName.c_str(), L"rb" ) )
      throw std::exception( "Could not open input file" );
  }

  AudioSource::~AudioSource()
  {
    if ( mFile )
      fclose( mFile );
  }

}