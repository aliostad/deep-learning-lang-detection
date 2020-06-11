#include "iostream"
#include "memory"
#include "tr1/memory"
#include "stdarg.h"
#include "stdio.h"

using namespace std;

enum logLevel{DEBUG=1, INFO=2, WARN=3, ERROR=4};

void log(int level, const char *str, ...)
{
	va_list args;
	
	va_start(args, str);
	if(level >= LOG_LEVEL)	
		vprintf(str, args);
	va_end(args);
}

class sample
{
	int data;
	int *dataPtr;

	public:
		sample(int a=0, int *b=0):data(a),dataPtr(b) { log(DEBUG, "Sample constructor %d:%u\n", data, dataPtr);}
		void showData(){log(DEBUG,"data=%d dataPtr=%u\n", data, dataPtr);}
		void setData(int a, int *b){data=a; dataPtr= b; log(DEBUG,"setting data=%d dataPtr=%u\n", data, dataPtr);}
		~sample() { delete dataPtr; data =0; log(DEBUG, "Sample destructor %d:%u\n", data, dataPtr);}
};

int main()
{
	std::auto_ptr<sample> sample_ap1(new sample());
	log(INFO, "auto ptr: sample_ap1 = %d\n", sample_ap1.get());

	std::auto_ptr<sample> sample_ap2(sample_ap1);
	log(INFO, "auto_ptr, after sample_ap2 = sample_ap1:\n  sample_ap1 = %d\n", sample_ap1.get());
	log(INFO, "sample_ap2 = %d\n", sample_ap2.get());
	std::tr1::shared_ptr<sample> sample_sp1(new sample());
	log(INFO, "shared ptr: sample_sp1 = %d:%d\n", sample_sp1.get(), sample_sp1.use_count());

	std::tr1::shared_ptr<sample> sample_sp2(sample_sp1);
	log(INFO, "shared_ptr, after sample_sp2 = sample_sp1:\n  sample_sp1 = %d:%d\n", sample_sp1.get(), sample_sp1.use_count());
	log(INFO, "sample_sp2 = %d:%d\n", sample_sp2.get(), sample_sp2.use_count());


	sample_sp1.reset();
	log(INFO, "shared_ptr, after releasing sample_sp1:\n  sample_sp1 = %d:%d\n", sample_sp1.get(), sample_sp1.use_count());
	log(INFO, "sample_sp2 = %d:%d\n", sample_sp2.get(), sample_sp2.use_count());
	return 0;
}

