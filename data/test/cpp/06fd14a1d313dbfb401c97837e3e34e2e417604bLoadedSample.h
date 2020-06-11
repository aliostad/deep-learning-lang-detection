#ifndef __LOADED_SAMPLE__
#define __LOADED_SAMPLE__

#include "BaseSample.h"
#include "../json/rapidjson/document.h"
#include "../bass/bass.h"

enum TError;
class String;


class LoadedSample : public BaseSample
{
public:
    LoadedSample ( const String* filename, TSample type );
	~LoadedSample();

	virtual TError Init();
	virtual void   End ();

    virtual void PlaySample ();
    virtual void PauseSample();
    virtual void StopSample ();

private:
    HSAMPLE		m_sample;
	HCHANNEL	m_channel;
    bool        m_playing;

};


#endif