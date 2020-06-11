//
// C++ Implementation: EthernetHandler
//
// Description: 
//
//
// Author: David Frey, ETZ G71.1 <freyd@ee.ethz.ch>, (C) 2009
//
// Copyright: See COPYING file that comes with this distribution
//
//

#include "EthernetHandler.h"


EthernetHandler::EthernetHandler() : TransportHandler(0)
{}

EthernetHandler::~EthernetHandler() 
{}

bool EthernetHandler::is_available()
{
	return true;
}

void EthernetHandler::open_ip_connection()
{
}

bool EthernetHandler::is_connected()
{
	return true;
}

void EthernetHandler::close_ip_connection() throw()
{
}

