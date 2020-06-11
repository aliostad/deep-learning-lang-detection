#ifndef SCORPION_OBJECTS_H
#define SCORPION_OBJECTS_H
#include "scorpion_engine.h"

namespace Scorpion {	
	class SCORPIONAPI NativeFunction : public Class {
	public:
		SCORPION_FUNCTION_PTR(invokePtr);
		NativeFunction(SCORPION_FUNCTION_PTR(invoke));
		void invoke(SCORPION_FUNCTION_ARGS);
	};

	class SCORPIONAPI ScorpionFunction : public Class {
		std::vector<Scorpion::Parser::line *> *lines;
	public:
		void invoke(SCORPION_FUNCTION_ARGS);
		ScorpionFunction(std::vector<Scorpion::Parser::line *> *lines);
		~ScorpionFunction();
	};

}

#endif