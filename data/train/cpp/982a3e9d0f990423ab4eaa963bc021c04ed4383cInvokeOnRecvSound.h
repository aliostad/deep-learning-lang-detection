/*
 * Created by okamoto on 2011-03-25
 */

#ifndef InvokeOnRecvSound_h
#define InvokeOnRecvSound_h

#include <sigverse/commonlib/comm/encoder/Encoder.h>

#include <string>

class RawSound;

namespace CommData {

class InvokeOnRecvSound : public RawDataEncoder
{
	enum { DATA_HEADER_BUFSIZE = 256, }; //TODO: Magic number
private:
	double      m_time;
	std::string m_caller;
	RawSound    &m_sound;
	char        m_dataHeaderBuf[DATA_HEADER_BUFSIZE];
	
public:
	InvokeOnRecvSound(double t, const char *caller, const char *target, RawSound & sound)
		: RawDataEncoder(COMM_INVOKE_CONTROLLER_ON_RECV_SOUND),
		  m_time(t), m_caller(caller), m_sound(sound)
	{
		setForwardTo(target, false);
	}

private:
	char * getDataHeader(int &);
	int    getDataLen();
	char * getData();
};

} // namespace

#if 1
typedef CommData::InvokeOnRecvSound CommInvokeMethodOnRecvSoundEncoder;
#else
// rename to CommInvokeMethodOnRecvSoundEncoder
typedef CommData::InvokeOnRecvSound CommInvokeMethodOnRecvSound;
#endif

#endif // InvokeOnRecvSound_h
 

