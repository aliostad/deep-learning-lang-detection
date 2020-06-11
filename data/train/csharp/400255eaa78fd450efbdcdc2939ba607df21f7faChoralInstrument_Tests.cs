using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LendingLibrary_Library.MusicSelection;

namespace LendingLibrary_Library_Tests
{
    [TestClass]
    public class ChoralInstrument_Tests
    {
        [TestMethod]
        public void TestChoralInstrumentConstructor_InitialzesFieldIsIncludedInChoralScoreCorrectly()
        {
            //act
            ChoralInstrument myChoralInstrument;

            //arrange
            myChoralInstrument = new ChoralInstrument("Oboe", false, true);

            //assert
            Assert.AreEqual(true, myChoralInstrument.IsIncludedInChoralScore);
        }

        [TestMethod]
        public void TestChoralInstrumentConstructor_InitialzesFieldInstrumentNameCorrectly()
        {
            //act
            ChoralInstrument myChoralInstrument;

            //arrange
            myChoralInstrument = new ChoralInstrument(instrumentName: "Oboe", createdByAdministrator: false, isIncludedInChoralScore: true);

            //assert
            Assert.AreEqual("oboe", myChoralInstrument.InstrumentName);
        }

        [TestMethod]
        public void TestChoralInstrumentConstructor_InitialzesFieldApprovedAsFalse()
        {
            //act
            ChoralInstrument myChoralInstrument;

            //arrange
            myChoralInstrument = 
                new ChoralInstrument(instrumentName: "Oboe", createdByAdministrator: false, isIncludedInChoralScore: true);

            //assert
            Assert.AreEqual(false, myChoralInstrument.Approved);
        }

        [TestMethod]
        public void TestChoralInstrumentConstructor_InitialzesFieldApprovedAsTrue()
        {
            //act
            ChoralInstrument myChoralInstrument;

            //arrange
            myChoralInstrument = 
                new ChoralInstrument(instrumentName: "Oboe",createdByAdministrator: true, isIncludedInChoralScore: false);

            //assert
            Assert.AreEqual(true, myChoralInstrument.Approved);
        }

        [TestMethod]
        public void TestChoralInstrumentConstructor_InitialzesFieldNumberOfTimesUsedAsOne()
        {
            //act
            ChoralInstrument myChoralInstrument;

            //arrange
            myChoralInstrument =
                new ChoralInstrument(instrumentName: "Oboe", createdByAdministrator: false, isIncludedInChoralScore: false);

            //assert
            Assert.AreEqual(1, myChoralInstrument.NumberOfTimesUsed);
        }

        [TestMethod]
        public void TestChoralInstrumentConstructor_InitialzesFieldNumberOfTimesUsedAsZero()
        {
            //act
            ChoralInstrument myChoralInstrument;

            //arrange
            myChoralInstrument =
                new ChoralInstrument(instrumentName: "Oboe", createdByAdministrator: true, isIncludedInChoralScore: false);

            //assert
            Assert.AreEqual(0, myChoralInstrument.NumberOfTimesUsed);
        }
    }
}
