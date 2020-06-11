#pragma once

#include "LightSample.h"
#include "Sample.h"
#include "RNG.h"
namespace Solstice {

	LightSampleOffsets::LightSampleOffsets(int p_count, Sample* p_sample){
		nSamples = p_count;	
		componentOffset = p_sample->Add1D(nSamples);
		posOffset = p_sample->Add2D(nSamples);
	}

	LightSample::LightSample(const Sample* p_sample, const LightSampleOffsets& p_offsets, uint32_t p_n){
		uPos[0] = p_sample->twoD[p_offsets.posOffset][2 * p_n];
		uPos[1] = p_sample->twoD[p_offsets.posOffset][2 * p_n + 1];

		uComponent = p_sample->oneD[p_offsets.componentOffset][p_n];
	}

	LightSample::LightSample(RNG& p_rng){
		uPos[0] = p_rng.RandomFloat();
		uPos[1] = p_rng.RandomFloat();
		uComponent = p_rng.RandomFloat();
	}

}
