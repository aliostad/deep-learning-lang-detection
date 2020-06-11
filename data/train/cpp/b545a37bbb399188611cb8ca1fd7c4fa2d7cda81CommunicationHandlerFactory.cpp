/*
 * CommunicationHandlerFactory.cpp
 *
 *  Created on: Apr 26, 2014
 *      Author: dariaz
 */

#include <communication/CommunicationHandlerFactory.hpp>
#include <communication/UartCommunicationHandler.hpp>
#include <stdio.h>

CommunicationHandlerFactory::CommunicationHandlerFactory() {
	// TODO Auto-generated constructor stub

}

CommunicationHandlerFactory::~CommunicationHandlerFactory() {
	// TODO Auto-generated destructor stub
}

ICommunicationHandler::ICommunicationHandler* CommunicationHandlerFactory::createHandler(string type) {
	if (type.compare("uart") == 0){
		UartCommunicationHandler::UartCommunicationHandler* handler = new UartCommunicationHandler();
		return handler;
	}
	else {
		printf ("ERROR::No such communication handler\n");
		return 0;
	}
}

