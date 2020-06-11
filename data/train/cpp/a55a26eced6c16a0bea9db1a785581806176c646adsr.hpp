#ifndef CDSP_PRIMITIVES_ENVELOPES_ADSR
#define CDSP_PRIMITIVES_ENVELOPES_ADSR

#include "../primitives_base.hpp"

namespace cdsp { namespace primitives { namespace envelopes {
	class adsr {
	public:
		adsr();
		adsr(types::sample _atk, types::sample _dcy, types::sample _sus, types::sample _rel);

		void perform(sample_buffer& buffer, types::disc_32_u block_size_leq, types::channel offset_channel = 0, types::index offset_sample = 0);

		void atk_set(types::sample _atk);
		void dcy_set(types::sample _dcy);
		void sus_set(types::sample _sus);
		void rel_set(types::sample _rel);

		void release();
		void reset();

	private:
		types::sample atk;
		types::sample dcy;
		types::sample sus;
		types::sample rel;
	};
}}}

#endif
