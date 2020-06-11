//
// C++ Implementation: sample_file
//
// Description: 
//
//
// Author: red <red@killy>, (C) 2006
//
// Copyright: See COPYING file that comes with this distribution
//
//
#include "sample_file.h"

namespace ReShaked {


SampleFile *SampleFile::singleton=NULL;

SampleFile *SampleFile::get_singleton() {
	
	return singleton;
}


SampleLoader::LoadStatus SampleFile::load_sample(String p_filename,Sample *p_sample) {
	
	for (int i=0;i<loaders.size();i++) {
		
		if (loaders[i]->load_sample(p_filename,p_sample)==SampleLoader::LOAD_OK)
			return SampleLoader::LOAD_OK;
	}
	
	
	return SampleLoader::LOAD_UNRECOGNIZED;
}

void SampleFile::add_loader(SampleLoader *p_loader) {
	
	loaders.push_back(p_loader);
}

SampleFile::SampleFile() {
	
	singleton=this;	
}


SampleFile::~SampleFile()
{
}


}
