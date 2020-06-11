#include "pch.h"
#include "Auto.h"
#include "MFAudioSample.h"
#include <mfapi.h>
#include <mfidl.h>
#include <mfreadwrite.h>
#include <mftransform.h>
#include <mferror.h>
#include <wrl.h>
#include <vector>

using namespace MediaExtension;
using namespace Platform;


MFAudioSample::MFAudioSample()
	:sampleDuration(0), sampleTime(0)
{

}

MFAudioSample::~MFAudioSample()
{

}

LONGLONG MFAudioSample::GetDuration()
{
	return this->sampleDuration;
}

LONGLONG MFAudioSample::GetSampleTime()
{
	return this->sampleTime;
}

void MFAudioSample::Lock(void** buffer, uint64_t* size)
{
	HRESULT hr = S_OK;
	DWORD sizeTmp;
	BYTE *bufTmp;

	hr = sampleBuffer->Lock(&bufTmp, NULL, &sizeTmp);

	*size = sizeTmp;
	*buffer = bufTmp;
}

void MFAudioSample::Unlock(void* buffer, uint64_t size)
{
	HRESULT hr = S_OK;
	hr = sampleBuffer->Unlock();
}

void MFAudioSample::Initialize(Microsoft::WRL::ComPtr<IMFSample> sample)
{
	HRESULT hr = S_OK;
	Auto::getInstance();
	hr = sample->GetSampleDuration(&sampleDuration);
	hr = sample->GetSampleTime(&sampleTime);
	hr = sample->ConvertToContiguousBuffer(&sampleBuffer);
}