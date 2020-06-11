/**
 * @author Robert Waury
 * @date September 22, 2011
 * @file unittests/xmltest.hpp
 */

#ifndef XMLTEST_HPP_
#define XMLTEST_HPP_

#include <cppunit/TestAssert.h>
#include <cppunit/extensions/HelperMacros.h>

namespace test {

/**
 * This class tests the XML loading and saving facilities for:
 *		the config file		(load)
 *		levels				(load)
 *		the material file	(load)
 */
class xmlTest : public CPPUNIT_NS::TestFixture {
	CPPUNIT_TEST_SUITE(xmlTest);
	/* config file */
	CPPUNIT_TEST(noConfigFileTest);
	CPPUNIT_TEST(loadConfigTest);
	CPPUNIT_TEST(loadConfigKeyMissingTest);
	CPPUNIT_TEST(loadConfigValueMissingTest);
    CPPUNIT_TEST(loadConfigNoRootTest);
	CPPUNIT_TEST(loadConfigEmptyRootTest);
	CPPUNIT_TEST(loadConfigUnknownTagTest);
	CPPUNIT_TEST(loadConfigBrokenTest);
	/* config file end */

	/* level files */
	CPPUNIT_TEST(noLevelFileTest);
	CPPUNIT_TEST(loadLevelTest);
	CPPUNIT_TEST(loadLevelEmptyRootTest);
	CPPUNIT_TEST(loadLevelEnvOnlyTest);
	CPPUNIT_TEST(loadLevelNoEnvTest);
	CPPUNIT_TEST(loadLevelNoRootTest);
	CPPUNIT_TEST(loadLevelRootUpBrokenTest);
	CPPUNIT_TEST(loadLevelRootPositionBrokenTest);
	CPPUNIT_TEST(loadLevelRootEyeBrokenTest);
	CPPUNIT_TEST(loadLevelCompoundMatrixBrokenTest);
	CPPUNIT_TEST(loadLevelJointTypeBrokenTest);
	CPPUNIT_TEST(loadLevelJointPivotBrokenTest);
	CPPUNIT_TEST(loadLevelJointPinDirBrokenTest);
	CPPUNIT_TEST(loadLevelObjectTypeBrokenTest);
	CPPUNIT_TEST(loadLevelObjectMaterialBrokenTest);
	CPPUNIT_TEST(loadLevelObjectMatrixBrokenTest);
	CPPUNIT_TEST(loadLevelObjectDampingBrokenTest);
	CPPUNIT_TEST(loadLevelEnvNoSuchModelTest);
	/* level files end*/

	/* materials file */
	CPPUNIT_TEST(noMaterialsFileTest);
	CPPUNIT_TEST(loadMaterialsTest);
	CPPUNIT_TEST(loadMaterialsAmbientBrokenTest);
	CPPUNIT_TEST(loadMaterialsDiffuseBrokenTest);
	CPPUNIT_TEST(loadMaterialsSpecularBrokenTest);
	CPPUNIT_TEST(loadMaterialsEmptyRoot);
	CPPUNIT_TEST(loadMaterialsNoRoot);
	CPPUNIT_TEST(loadMaterialsNoPairsTest);
	CPPUNIT_TEST(loadMaterialsNoMaterialsTest);
	CPPUNIT_TEST(loadMaterialsNoSuchShaderTest);
	CPPUNIT_TEST(loadMaterialsNoSuchSoundTest);
	CPPUNIT_TEST(loadMaterialsNoSuchTextureTest);
	CPPUNIT_TEST(loadMaterialsNoSuchTexture1Test);
	CPPUNIT_TEST(loadMaterialsUnknownMatInPairTest);
	/* materials file end */

	/* template files */
	/*
	CPPUNIT_TEST(noTemplateFileTest);
	CPPUNIT_TEST(loadTemplateTest);

	CPPUNIT_TEST(loadTemplateNoRootTest);
	*/
	/* template files end */

	CPPUNIT_TEST_SUITE_END();

public:
	void setUp();
	void tearDown();
protected:
	
	void noConfigFileTest();
	void loadConfigTest();
	void loadConfigKeyMissingTest();
	void loadConfigValueMissingTest();
	void loadConfigNoRootTest();
	void loadConfigEmptyRootTest();
	void loadConfigUnknownTagTest();
	void loadConfigBrokenTest();

	void noLevelFileTest();
	void loadLevelTest();
	void loadLevelEmptyRootTest();
	void loadLevelEnvOnlyTest();
	void loadLevelNoEnvTest();
	void loadLevelNoRootTest();
	void loadLevelCompoundMatrixBrokenTest();
	void loadLevelRootUpBrokenTest();
	void loadLevelRootEyeBrokenTest();
	void loadLevelRootPositionBrokenTest();
	void loadLevelJointTypeBrokenTest();
	void loadLevelJointPivotBrokenTest();
	void loadLevelJointPinDirBrokenTest();
	void loadLevelEnvNoSuchModelTest();
	void loadLevelObjectTypeBrokenTest();
	void loadLevelObjectMaterialBrokenTest();
	void loadLevelObjectMatrixBrokenTest();
	void loadLevelObjectDampingBrokenTest();

	void noMaterialsFileTest();
	void loadMaterialsTest();
	void loadMaterialsAmbientBrokenTest();
	void loadMaterialsDiffuseBrokenTest();
	void loadMaterialsSpecularBrokenTest();
	void loadMaterialsEmptyRoot();
	void loadMaterialsNoRoot();
	void loadMaterialsNoPairsTest();
	void loadMaterialsNoMaterialsTest();
	void loadMaterialsNoSuchShaderTest();
	void loadMaterialsNoSuchSoundTest();
	void loadMaterialsNoSuchTextureTest();
	void loadMaterialsNoSuchTexture1Test();
	void loadMaterialsUnknownMatInPairTest();
};

}

#endif /* XMLTEST_HPP_ */