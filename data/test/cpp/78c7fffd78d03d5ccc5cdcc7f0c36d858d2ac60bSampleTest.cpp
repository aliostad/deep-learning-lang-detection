#include "SampleTest.h"



CPPUNIT_TEST_SUITE_REGISTRATION(SampleTest);

SampleTest::SampleTest() {
}

SampleTest::~SampleTest() {
}

void SampleTest::setUp() {
}

void SampleTest::tearDown() {
}

void SampleTest::testConstructor() {
    Sample s1 (1,0);
    CPPUNIT_ASSERT_EQUAL((float)1,s1.getX());
    CPPUNIT_ASSERT_EQUAL((float)0,s1.getY());
}
void SampleTest::testEquals() {
    Sample s1 (1,0);
    Sample s2 (1,0);
    Sample s3 (1,1);
    CPPUNIT_ASSERT(s1.equals(&s2));
    CPPUNIT_ASSERT(!s1.equals(&s3));
}
void SampleTest::testSetters() {
    Sample s1 (1,0);
    s1.setX(0);
    CPPUNIT_ASSERT_EQUAL((float)0,s1.getX());
    s1.setY(1);
    CPPUNIT_ASSERT_EQUAL((float)1,s1.getY());
}

