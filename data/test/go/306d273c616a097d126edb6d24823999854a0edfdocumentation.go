//
//  2016 October 13
//  John Gilliland [jgilliland@grail.com]
//  instrument-api package
//

/*
    Package instrument-api is an RPC Server that exposes the Instrument Provider API for the Hamilton Robotics, Inc. STAR 
    instruments.  Access to the instruments Venus software is achieved using Windows COM objects.  Access to the 
    Windows COM system is achieved using the github.com/go-ole/go-ole package.

    The instrument package contains an implementation of the InstrumentProvider contract for use with Hamilton robots
    for more information about this interface see the automation contracts package.
*/
package instrument-api
