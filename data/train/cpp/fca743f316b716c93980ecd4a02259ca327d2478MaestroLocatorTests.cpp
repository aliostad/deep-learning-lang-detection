//Copyright (c) 2014, IDEO 

#include "NoamServerLocator.h"
#include "CppUTest/TestHarness.h"

TEST_GROUP(MaestroLocator)
{

};

TEST(MaestroLocator, parsesEmptyDatagram) {
	NoamServerLocator locator;
	CHECK_EQUAL(-1, locator.parsePort(""));
	CHECK_EQUAL(-1, locator.parsePort(0));
}

TEST(MaestroLocator, parsesMaestroPort) {
	NoamServerLocator locator;
	CHECK_EQUAL(45993, locator.parsePort("[Maestro@45993]"));
	CHECK_EQUAL(783, locator.parsePort("[Maestro@783]"));
}

TEST(MaestroLocator, parsesMissingPort) {
	NoamServerLocator locator;
	CHECK_EQUAL(-1, locator.parsePort("[Maestro@]"));
	CHECK_EQUAL(0, locator.parsePort("[Maestro@0]"));
}

