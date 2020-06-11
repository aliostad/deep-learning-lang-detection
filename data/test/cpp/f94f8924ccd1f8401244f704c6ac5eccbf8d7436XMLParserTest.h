/*
 *  XMLParserTest.h
 *  MonkeyWorksCore
 *
 *  Created by bkennedy on 12/21/08.
 *  Copyright 2008 mit. All rights reserved.
 *
 */

#ifndef XML_PARSER_TEST_H
#define XML_PARSER_TEST_H

#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>
#include "FullCoreEnvironmentTest.h"
#include "boost/filesystem.hpp"

namespace mw {
	class XMLParserTestFixture : public FullCoreEnvironmentTestFixture {
		
		
		CPPUNIT_TEST_SUITE( XMLParserTestFixture );
		CPPUNIT_TEST( testLoadBool_1 );
		CPPUNIT_TEST( testLoadBool_0 );
		CPPUNIT_TEST( testLoadBool_true );
		CPPUNIT_TEST( testLoadBool_false );
		CPPUNIT_TEST( testLoadBool_TRUE );
		CPPUNIT_TEST( testLoadBool_FALSE );
		CPPUNIT_TEST( testLoadBool_yes );
		CPPUNIT_TEST( testLoadBool_no );
		CPPUNIT_TEST( testLoadBool_YES );
		CPPUNIT_TEST( testLoadBool_NO );
		CPPUNIT_TEST( testLoadInt );
		CPPUNIT_TEST( testLoadIntNegative );
		CPPUNIT_TEST( testLoadIntExpression );
		CPPUNIT_TEST( testLoadIntAttribute );
		CPPUNIT_TEST( testLoadIntAttributeClosingTag );
		CPPUNIT_TEST( testLoadIntSpaces );
		CPPUNIT_TEST( testLoadFloat );
		CPPUNIT_TEST( testLoadString );
		CPPUNIT_TEST( testLoadStringAttribute );
		CPPUNIT_TEST( testLoadStringSpaces );
		CPPUNIT_TEST( testLoadDictionary );
		CPPUNIT_TEST( testLoadDictionaryInDictionary );
		CPPUNIT_TEST( testLoadList );
		CPPUNIT_TEST( testLoadListWithinList );
		CPPUNIT_TEST( testLoadListInDictionary );
		CPPUNIT_TEST( testLoadDictionaryInList );

		CPPUNIT_TEST( testSaveThenLoadBool );
		CPPUNIT_TEST( testSaveThenLoadInteger );
		CPPUNIT_TEST( testSaveThenLoadFloat );
		CPPUNIT_TEST( testSaveThenLoadString );
		CPPUNIT_TEST( testSaveThenLoadDict );
		CPPUNIT_TEST( testSaveThenLoadList );
		CPPUNIT_TEST( testSaveThenLoadListInList );
		CPPUNIT_TEST( testSaveThenLoadDictInDict );
		CPPUNIT_TEST( testSaveThenLoadListInDict );
		CPPUNIT_TEST( testSaveThenLoadDictInList );
		CPPUNIT_TEST_SUITE_END();
	public:
		void setUp();
		void tearDown();
		
		void testLoadBool_1();
		void testLoadBool_0();
		void testLoadBool_true();
		void testLoadBool_false();
		void testLoadBool_TRUE();
		void testLoadBool_FALSE();
		void testLoadBool_yes();
		void testLoadBool_no();
		void testLoadBool_YES();
		void testLoadBool_NO();
		void testLoadInt();
		void testLoadIntNegative();
		void testLoadIntExpression();
		void testLoadIntSpaces();
		void testLoadIntAttribute();
		void testLoadIntAttributeClosingTag();
		void testLoadFloat();
		void testLoadString();
		void testLoadStringAttribute();
		void testLoadStringSpaces();
		void testLoadDictionary();
		void testLoadDictionaryInDictionary();
		void testLoadList();
		void testLoadListWithinList();
		void testLoadListInDictionary();
		void testLoadDictionaryInList();
		
		void testSaveThenLoadBool();
		void testSaveThenLoadInteger();
		void testSaveThenLoadFloat();
		void testSaveThenLoadString();
		void testSaveThenLoadDict();
		void testSaveThenLoadList();
		void testSaveThenLoadListInList();
		void testSaveThenLoadDictInDict();
		void testSaveThenLoadListInDict();
		void testSaveThenLoadDictInList();
		
	private:
		boost::filesystem::path temp_xml_file_path;
		boost::shared_ptr<mw::GlobalVariable> testVar;
		
		void writeToFile(const std::string &text);
	};
}
#endif



