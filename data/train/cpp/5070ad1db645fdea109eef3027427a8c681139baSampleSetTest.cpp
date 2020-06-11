#include "stdafx.h"
#include "CppUnitTest.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;
using namespace Common;

namespace Fast_kNCN_Test
{	
	SampleSet* testSampleSet;
	SampleSetFactory* ssf;

	TEST_CLASS(SampleSetTest)	{
	private:
		TEST_CLASS_INITIALIZE(SampleSetTestSetUp) {	

			testSampleSet = new SampleSet();
			ssf = new SampleSetFactory();

			*testSampleSet = ssf->createSampleSet("../../Datasets/ftrain01.txt");
			Assert::IsNotNull(&testSampleSet);

			Assert::AreEqual(8, testSampleSet->nrClasses);
			Assert::AreEqual(30, testSampleSet->nrDims);
			Assert::AreEqual(1400, testSampleSet->nrSamples);
		}

		TEST_CLASS_CLEANUP(SampleSetTestTearDown) {
			delete testSampleSet;
			delete ssf;
		}

	public:
		TEST_METHOD(ConstructorSampleSet) {
			SampleSet testSampleSet2(8, 30, 1400);
			Assert::IsNotNull(&testSampleSet2);

			testSampleSet2 = ssf->createSampleSet("../../Datasets/ftrain01.txt");
			Assert::AreEqual(*testSampleSet, testSampleSet2);
		}

		TEST_METHOD(CopyConstructorSampleSet) {
			SampleSet copySampleSet(*testSampleSet);

			Assert::AreEqual(*testSampleSet, copySampleSet);
			Assert::AreNotSame(testSampleSet, &copySampleSet);

			SampleSet copySampleSet2 = *testSampleSet;

			Assert::AreEqual(*testSampleSet, copySampleSet2);
		}

		TEST_METHOD(AssignmentOperatorSampleSet) {
			SampleSet testSampleSet2;
			Assert::IsNotNull(&testSampleSet2);

			testSampleSet2 = *testSampleSet;
			Assert::AreEqual(*testSampleSet, testSampleSet2);

			SampleSet testSampleSet3(8, 30, 1400);
			Assert::IsNotNull(&testSampleSet3);

			testSampleSet3 = *testSampleSet;
			Assert::AreEqual(*testSampleSet, testSampleSet3);
		}

		TEST_METHOD(ExplicitEqualityOperatorSampleSet) {
			SampleSet testSampleSet7 = *testSampleSet;
			Assert::IsNotNull(&testSampleSet7);
			Assert::IsTrue(testSampleSet7 == *testSampleSet);
		}

		TEST_METHOD(UnequalSampleSet) {
			SampleSet otherSampleSet;
			Assert::IsNotNull(&otherSampleSet);

			otherSampleSet = ssf->createSampleSet("../Fast_k-NCN/Datasets/ftrain02.txt");
			Assert::IsNotNull(&otherSampleSet);
			Assert::AreNotEqual(8, otherSampleSet.nrClasses);
			Assert::AreNotEqual(30, otherSampleSet.nrDims);
			Assert::AreNotEqual(1400, otherSampleSet.nrSamples);
			Assert::AreNotEqual(*testSampleSet, otherSampleSet);
		}

		TEST_METHOD(UnequalSampleDiffNrSamplesSet) {
			SampleSet otherSampleSet2;
			Assert::IsNotNull(&otherSampleSet2);

			otherSampleSet2 = ssf->createSampleSet("../Fast_k-NCN/Datasets/ftrain02.txt", 100);
			Assert::IsNotNull(&otherSampleSet2);
			Assert::AreNotEqual(8, otherSampleSet2.nrClasses);
			Assert::AreNotEqual(30, otherSampleSet2.nrDims);
			Assert::AreNotEqual(100, otherSampleSet2.nrSamples);
			Assert::AreNotEqual(*testSampleSet, otherSampleSet2);
		}
	};
}