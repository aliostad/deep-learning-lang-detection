#include "stdafx.h"
#include "CppUnitTest.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;
using namespace Common;

namespace Fast_kNCN_Test
{	
	const SampleDim firstSampleDims[] = {-0.3490f, 0.6482f, 0.2710f, -0.3151f,
		1.1199f, 1.5135f, 0.1179f, 1.2082f,
		1.1918f, 1.1449f, 0.9726f, -0.2358f,
		1.2261f, -0.2806f, 0.4784f, -0.3126f,
		0.1192f, -0.3256f, 0.0434f, -0.3327f,
		0.0022f, -0.3364f, -0.0148f, -0.3418f,
		-0.0261f, -0.3483f, -0.0400f, -0.3543f,
		-0.0515f, -0.3602f};

	const SampleDim secondSampleDims[] = {-0.3490f, 0.6482f, 0.2710f, -0.3151f,
		1.1199f, 1.5135f, 0.1179f, 1.2082f,
		1.1918f, 1.1449f, 0.9726f, -0.2358f,
		1.2261f, -0.2806f, 0.4784f, -0.3126f,
		0.1192f, -0.3256f, 0.0434f, -0.3327f,
		0.0022f, -0.3364f, -0.0148f, -0.3418f,
		-0.0261f, -0.3483f, -0.0400f, -0.3543f,
		-0.0515f, -0.3601f};

	TEST_CLASS(SampleSetTest)	{
		static Sample testSample;
		static SampleSetFactory sf;

		public:
		TEST_METHOD_INITIALIZE(SampleTestSetUp) {	

			testSample = Sample();
			sf = SampleSetFactory();
			std::ifstream trainfile("../../Datasets/ftrain01.txt");

			Assert::IsTrue(trainfile.is_open());

			int nrClasses, nrDims, nrSamples;

			trainfile >> nrClasses;
			trainfile >> nrDims;
			trainfile >> nrSamples;

			nrDims = 8;

			Assert::AreEqual(8, nrClasses);
			Assert::AreEqual(8, nrDims);
			Assert::AreEqual(1400, nrSamples);

			testSample = sf.createSample(trainfile, 0, nrDims);

			Assert::AreEqual(1, testSample.label);
			Assert::AreEqual(nrDims, testSample.nrDims);
			Assert::IsNotNull(testSample.dims);

			Assert::AreEqual(firstSampleDims[testSample.nrDims - 1], testSample[testSample.nrDims - 1]);
			Assert::AreEqual(firstSampleDims[testSample.nrDims - 1], testSample[testSample.nrDims - 1]);
		}

		TEST_METHOD(ConstructorSample)
		{
			Sample testSample2(0, 1, 30, firstSampleDims);

			Assert::AreEqual(0, testSample2.index);
			Assert::AreEqual(1, testSample2.label);
			Assert::AreEqual(30, testSample2.nrDims);
			Assert::IsNotNull(&testSample2.dims);
			Assert::AreEqual(firstSampleDims[0], testSample2[0]);
			Assert::AreEqual(firstSampleDims[29], testSample2[29]);}

		TEST_METHOD(CopyConstructorSample)
		{
			Assert::IsNotNull(&testSample);
			
			Sample copySample(testSample);

			Assert::IsNotNull(&copySample);
			Assert::AreNotSame(&testSample, &copySample);
			Assert::AreEqual(testSample.index, copySample.index);
			Assert::AreEqual(testSample.label, copySample.label);
			Assert::AreEqual(testSample.nrDims, copySample.nrDims);

			Sample copySample2 = testSample; // invoke copy constructor

			Assert::IsNotNull(&copySample2);
			Assert::AreNotSame(&testSample, &copySample2);
			Assert::AreEqual(testSample.index, copySample2.index);
			Assert::AreEqual(testSample.label, copySample2.label);
			Assert::AreEqual(testSample.nrDims, copySample2.nrDims);
		}

		TEST_METHOD(AssignmentOperatorSample)
		{
			Assert::IsNotNull(&testSample);
			Sample assignSample = testSample; // invoke copy constructor

			assignSample = testSample;
			Assert::AreEqual(testSample, assignSample);
			Assert::AreNotSame(&testSample, &assignSample);

			assignSample = assignSample; // self assignment
			Assert::AreEqual(testSample, assignSample);
			Assert::AreNotSame(&testSample, &assignSample);
		}

		TEST_METHOD(ExplicitEqualityOperatorSample)
		{
			Assert::IsNotNull(&testSample);
			Sample testSample3(testSample);
			Assert::IsTrue(testSample3 == testSample);
		}

		TEST_METHOD(UnequalSample)
		{
			Sample otherSample(1, 1, 30, firstSampleDims);
			Sample otherSample2(2, 2, 30, secondSampleDims);

			Assert::AreEqual(firstSampleDims[0], otherSample[0]);
			Assert::AreEqual(firstSampleDims[29], otherSample[29]);
			Assert::AreEqual(secondSampleDims[0], otherSample2[0]);
			Assert::AreEqual(secondSampleDims[29], otherSample2[29]);

			Assert::AreNotEqual(otherSample[29], otherSample2[29]);
		}

	};
			
	Sample SampleSetTest::testSample;
	SampleSetFactory SampleSetTest::sf;

}