/*
* EthpacketDump.h
* Ethernet packet dump library header
*/

#ifndef _ETHPACKETDUMP_LIB_H
#define _ETHPACKETDUMP_LIB_H

#include <inttypes.h>
#if (ARDUINO >= 100)
#include <Arduino.h>
#else
#include <wprogram.h>
#endif
#include <avr/pgmspace.h>

/* Any #defines */

class EthPacketDump {
  private:
	HardwareSerial *_Serial;
	void print( const prog_char *progmem_s );
	void println( const prog_char *progmem_s );
	void printIP( uint8_t *buf, int startByte );
	void printMac( uint8_t *buf, int startByte );
	void dumpHexAscii( uint8_t *buf, int offset, int payloadLen );
	void dumpHex( uint8_t *buf, int plen );
	void dumpEthernetHeader( uint8_t *buf );
	void dumpArp( uint8_t *buf );
	void dumpIpHeader( uint8_t *buf );
	void dumpTcp( uint8_t *buf );
	void dumpDns( uint8_t *buf, int plen );
	void dumpDhcp( uint8_t *buf );
	void dumpNtp( uint8_t *buf );

  public:
  	EthPacketDump( void );
	void begin( HardwareSerial *serIn, boolean dumpPacket, boolean ethernetDump,
			boolean arpDump, boolean packetDetails, int packetBufSize );


	void packetDump( uint8_t *buf, int plen );

};

#endif //_ETHPACKETDUMP_H

