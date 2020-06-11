#include <vector>
namespace Synth {
	typedef Sample float;
	typedef SampleNum uint32_t;
	class Modifier {
		virtual void render(Sample* data);
	}
	class Stream {
		virtual Sample* render(SampleNum rate,float time);
		std::vector<Modifier*> modifiers;
	};
	class ConstStream: Stream {
		Sample value;
		Sample* render(SampleNum rate,float time);
	}
	class SineStream: Stream {
		SampleNum offset;
		Sample* render(SampleNum rate,float time);
	};
	class SquareStream: Stream {
		SampleNum offset;
		Sample* render(SampleNum rate,float time);
	};
	class TriangleStream: Stream {
		SampleNum offset;
		Sample* render(SampleNum rate,float time);
	};
	class SawtoothStream: Stream {
		SampleNum offset;
		Sample* render(SampleNum rate,float time);
	};
	class Add: Stream {
		Stream param;
		virtual void render(Sample* data);
	}
}