#ifndef WB_SAMPLE_V8_H
#define WB_SAMPLE_V8_H

#include "wb-global.h"

#include "wbv8.h"
#include "ObjectWrap.h"
#include "../../Sound/Sample.h"

namespace chi {

class Sample_v8 : public ObjectWrap {

public:

	~Sample_v8();

	static void Register(v8::Handle<v8::Object> target);

	static v8::Handle<v8::Object> New(Sample *sample);

	Sample *wrappedSample();

private:

	Sample_v8(v8::Handle<v8::Object> wrapper, Sample *sample = NULL);

	static v8::Handle<v8::Value> New(const v8::Arguments &args);

	static v8::Handle<v8::Value> Play(const v8::Arguments &args);

	static v8::Handle<v8::Value> Load(const v8::Arguments &args);

	static v8::Persistent<v8::FunctionTemplate> constructor_template;

	Sample *sample;
	bool owns;
};

}

#endif // WB_SAMPLE_V8_H
