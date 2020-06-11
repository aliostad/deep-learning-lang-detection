#include <Sampler/Sampler.h>
#include <cstdlib>
#include <utility>
NRook::NRook(int num) :Sampler(num)
{
	for (int i = 0; i < num; i++)
	{
        sampleList[i].x = static_cast<float>(i) / numSample;
        sampleList[i].y = static_cast<float>(i) / numSample;
        sampleList[i].z = 0;
	}
}

void NRook::shuffle()
{
	for (int i = numSample-1; i>0; i--)
	{
		int targetX = randomGen->getRandomI(0, i+1);
		std::swap(sampleList[i].x, sampleList[targetX].x);
		//int targetY = randomGen.getRandomI(0, i - 1);
		//std::swap(sampleList[i].y, sampleList[targetX].y);
	}
}
