/*
 *  TestHandlerFactory.cpp
 *  Ape
 *
 *  Created by Romko on 5/27/10.
 *  Copyright 2010 Romko Goofique independent. All rights reserved.
 *
 */

#include "TestHandlerFactory.h"

#include <Ape.Web.Test/Ape.Web.Test/TestHandler>

APE_EXPORT(TestHandlerFactory, Ape::Web::Test::TestHandlerFactory, Ape::Http::Server::Handling::IHttpHandlerFactory)

namespace Ape {
	namespace Web {
		namespace Test {
			using namespace Ape;
			using namespace Ape::Net;
			using namespace Ape::Http::Server;
			using namespace Ape::Http::Server::Handling;
			
			TestHandlerFactory::TestHandlerFactory() {
				printf("TestHandlerFactory::TestHandlerFactory()\n");
			}
			TestHandlerFactory::~TestHandlerFactory() {}
			
			void TestHandlerFactory::Init(HttpServer* server) {
				printf("TestHandlerFactory::Init(server)\n");
				m_Server = server;
			}
			IHttpHandler* TestHandlerFactory::CreateHandler(HttpWorker* worker) {
				printf("TestHandlerFactory::CreateHandler(worker)\n");
				return new TestHandler(m_Server, worker);
			}
			void TestHandlerFactory::DisposeHandler(IHttpHandler* handler) {
				printf("TestHandlerFactory::DisposeHandler(handler)\n");
				delete handler;
			}
		}
	}
}
