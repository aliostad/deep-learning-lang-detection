

#ifndef gprs_h
#define gprs_h

#include <Stream.h>

class GPRS
{
public:
  GPRS();
  ~GPRS();
  void disableEcho(Stream* stream);
  void storeConfig(Stream* stream);
  bool configureSMS(Stream* stream);
  bool reset(Stream* stream);
  bool ok(Stream* stream);
  bool quality(Stream* stream);
  bool sendSMS(Stream* stream, char* number, char* msg);
  bool sendTCP(Stream* stream, char* host, int port, char* data);
  bool readOK(Stream* stream);
  bool readPrompt(Stream* stream);
  bool readTcpPrompt(Stream* stream);
  void testMatchChars();
  bool matchChars(Stream* stream, char* match, long timeout = -1, char* alt1 = 0);
  bool readUntil(Stream* stream, char* buffer, int buflen, char match, long timeout = -1);
};


#endif

