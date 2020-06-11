#include "Media/MediaSampleFactory.h"
#include "boost/foreach.hpp"

using namespace Limitless;

MediaSampleFactory::MediaSampleNodes MediaSampleFactory::s_mediaSampleNodes;
unsigned int MediaSampleFactory::s_sampleTypeIndex=0;

SharedMediaSample MediaSampleFactory::createType(std::string typeName)
{
	BOOST_FOREACH(MediaSampleNode &mediaSampleNode, s_mediaSampleNodes)
	{
		if(mediaSampleNode.typeName() == typeName)
		{
			SharedMediaSample object(mediaSampleNode.factoryFunction());
			
			if(object != SharedMediaSample())
				return object;
			break;
		}
	}

	return SharedMediaSample();
}

SharedMediaSample MediaSampleFactory::createType(unsigned int type)
{
	if((type < 0) || (type >= s_mediaSampleNodes.size()))
		return SharedMediaSample();

	SharedMediaSample object(s_mediaSampleNodes[type].factoryFunction());

	return object;
}

size_t MediaSampleFactory::getTypeId(std::string typeName)
{
	BOOST_FOREACH(MediaSampleNode &mediaSampleNode, s_mediaSampleNodes)
	{
		if(mediaSampleNode.typeName() == typeName)
			return mediaSampleNode.type();
	}
	return -1;
}