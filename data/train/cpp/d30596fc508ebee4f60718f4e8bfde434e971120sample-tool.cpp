#include "sample-tool.h"
#include "generated/config.h"

#include <sample/sample.h>

#include <iostream>

CREATE_TOOL(SampleTool,SAMPLE_TOOL)

SampleTool::SampleTool() {
}

SampleTool::~SampleTool() {
}

void SampleTool::registerProperties( util::cfg::cmd::CommandLine &cmd ) {
	Tool::registerProperties( cmd );
	registerCfg("text", "Text to convert", std::string("Hello World!"), true);
}

int SampleTool::run( util::cfg::cmd::CommandLine & /*cmd*/ ) {
	
	sample::Sample sample;
	char* out_string;
	
	std::string in_string = util::cfg::getValue<std::string>("tool.text");
	
	out_string = sample.convert((char*) in_string.c_str());
	
	std::cout << out_string << std::endl;
	
	return 0;
}
