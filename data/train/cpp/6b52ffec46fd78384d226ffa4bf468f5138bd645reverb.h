#ifndef THELONIOUS_REVERB_H
#define THELONIOUS_REVERB_H

#include "thelonious/types.h"
#include "thelonious/processor.h"
#include "thelonious/parameter.h"
#include "thelonious/util.h"
#include "thelonious/constants/sizes.h"

namespace thelonious {
namespace dsp {
namespace delays {

class Reverb : public Processor<1, 1> {
public:
    Reverb(Sample time=0.7, Sample mix=0.2) : time(time), mix(mix) {}

    void tick(Block<1> &inputBlock, Block<1> &outputBlock) {
        Chock timeChock = time.get();
        Chock mixChock = mix.get();
        for (uint32_t i=0; i<constants::BLOCK_SIZE; i++) {
            Sample inputSample = inputBlock[0][i];
            Sample time = timeChock[i];
            Sample mix = mixChock[i];

            // First input AP
            Sample bufferSample = inputAp1[inputApIndex1];
            Sample delaySample = inputBlock[0][i] + 0.625 * bufferSample;
            inputAp1[inputApIndex1] = delaySample;
            Sample outputSample = bufferSample - 0.625 * delaySample;

            // Second input AP
            bufferSample = inputAp2[inputApIndex2];
            delaySample = outputSample + 0.625 * bufferSample;
            inputAp2[inputApIndex2] = delaySample;
            outputSample = bufferSample - 0.625 * delaySample;

            // Third input AP
            bufferSample = inputAp3[inputApIndex3];
            delaySample = outputSample + 0.625 * bufferSample;
            inputAp3[inputApIndex3] = delaySample;
            outputSample = bufferSample - 0.625 * delaySample;

            // Fourth input AP
            bufferSample = inputAp4[inputApIndex4];
            delaySample = outputSample + 0.625 * bufferSample;
            inputAp4[inputApIndex4] = delaySample;
            outputSample = bufferSample - 0.625 * delaySample;

            Sample sampleA = loopDelay1[loopDelayIndex1] * time;
            Sample sampleB = loopDelay2[loopDelayIndex2] * time;

            // First loop AP
            bufferSample = loopAp1[loopApIndex1];
            delaySample = sampleA + 0.625 * bufferSample;
            inputAp2[inputApIndex2] = delaySample;
            sampleA = bufferSample - 0.625 * delaySample;

            // Second loop AP
            bufferSample = loopAp2[loopApIndex2];
            delaySample = sampleB + 0.625 * bufferSample;
            inputAp2[inputApIndex2] = delaySample;
            sampleB = bufferSample - 0.625 * delaySample;


            // First loop delay
            loopDelay1[loopDelayIndex1] = outputSample + sampleB;
            // Second loop delay
            loopDelay2[loopDelayIndex2] = sampleA;

            outputBlock[0][i] = inputSample * (1.f - mix ) +
                                (sampleA + sampleB) * mix;

            inputApIndex1++;
            inputApIndex1 %= inputAp1.size();
            inputApIndex2++;
            inputApIndex2 %= inputAp2.size();
            inputApIndex3++;
            inputApIndex3 %= inputAp3.size();
            inputApIndex4++;
            inputApIndex4 %= inputAp4.size();

            loopDelayIndex1++;
            loopDelayIndex1 %= loopDelay1.size();
            loopDelayIndex2++;
            loopDelayIndex2 %= loopDelay2.size();

            loopApIndex1++;
            loopApIndex1 %= loopAp1.size();
            loopApIndex2++;
            loopApIndex2 %= loopAp2.size();

        }
    }

    Parameter time;
    Parameter mix;

private:
    Channel<122> inputAp1;
    Channel<303> inputAp2;
    Channel<553> inputAp3;
    Channel<922> inputAp4;

    uint32_t inputApIndex1;
    uint32_t inputApIndex2;
    uint32_t inputApIndex3;
    uint32_t inputApIndex4;

    Channel<8500> loopDelay1;
    Channel<7234> loopDelay2;

    uint32_t loopDelayIndex1;
    uint32_t loopDelayIndex2;

    Channel<3823> loopAp1;
    Channel<4732> loopAp2;

    uint32_t loopApIndex1;
    uint32_t loopApIndex2;
};

} // namespace delays
} // namespace dsp
} // namespace thelonious

#endif
