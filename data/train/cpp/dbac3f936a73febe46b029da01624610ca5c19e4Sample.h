#pragma once
#include "Solstice.h"

namespace Solstice {

	class CameraSample {
	public:
		int pixel_position_x, pixel_position_y;
		float image_x, image_y;

	};

	class Sample : public CameraSample {
	public:
		/* Sample Public Methods */
		Sample();
		Sample(Sampler* p_sampler, Integrator* p_integrator, const Scene* p_scene);
		uint32_t Add1D(uint32_t num);
		uint32_t Add2D(uint32_t num);
		void AllocateSampleMemory();
		Sample* Duplicate(int count) const;
		~Sample(){
			if (oneD != nullptr) {
				delete oneD[0];
				delete oneD;
			}
		}
		/* Sample Public Data*/
		std::vector<uint32_t> n1D, n2D;
		float **oneD, **twoD;
	private:
		/* Sample Private Methods*/

	};
}
