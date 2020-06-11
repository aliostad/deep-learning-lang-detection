using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LendingLibrary_Library.MusicSelection;
namespace LendingLibrary_Library_Tests
{
    [TestClass]
    public class Instrument_Tests
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class Instrument, constructor.  Argument instrumentName cannot be null, empty string, or white space.")]
        public void TestInstrumentationConstructor_ArgumentInstrumentNameIsNull_ThrowsArgumentException()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument(null, true);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class Instrument, constructor.  Argument instrumentName cannot be null, empty string, or white space.")]
        public void TestInstrumentationConstructor_ArgumentInstrumentNameIsEmptyString_ThrowsArgumentException()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument("", true);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class Instrument, constructor.  Argument instrumentName cannot be null, empty string, or white space.")]
        public void TestInstrumentationConstructor_ArgumentInstrumentNameIsWhiteSpace_ThrowsArgumentException()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument("  ", true);
        }

        [TestMethod]
        public void TestInstrumentConstructor_ArgumentCreatedByAdministratorIsTrueNumberOfTimesUsedShouldBeSetToZero()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument("Flute", true);

            //Assert
            Assert.AreEqual(0, myInstrument.NumberOfTimesUsed);
        }

        [TestMethod]
        public void TestInstrumentConstructor_ArgumentCreatedByAdministratorIsFalseNumberOfTimesUsedShouldBeSetToOne()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument("Flute", false);

            //Assert
            Assert.AreEqual(1, myInstrument.NumberOfTimesUsed);
        }

        [TestMethod]
        public void TestInstrumentConstructor_FieldInstrumentNameIsStrippedOfWhiteSpace()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument("  Flute  ", false);

            //Assert
            Assert.AreEqual("flute", myInstrument.InstrumentName);
        }

        [TestMethod]
        public void TestInstrumentConstructor_FieldInstrumentNameIsSetAsLowerCase()
        {
            //Arrange
            Instrument myInstrument;

            //Act
            myInstrument = new Instrument("FluTE", false);

            //Assert
            Assert.AreEqual("flute", myInstrument.InstrumentName);
        }


        [TestMethod]
        public void TestInstrument_MethodIncrementNumberOfTimesUsed()
        {
            //Arrange
            Instrument myInstrument = new Instrument("Flute", false);

            //Act
            myInstrument.IncrementNumberOfTimesUsed();

            //Assert
            Assert.AreEqual(2, myInstrument.NumberOfTimesUsed);
        }

        [TestMethod]
        public void TestInstrument_MethodIncrementNumberOfTimesUsedTriggersFieldApprovedToBeTrue()
        {
            //Arrange
            Instrument myInstrument = new Instrument("Flute", false);

            //Act
            for (int i = 0; i <= 48; i++)
            {
                myInstrument.IncrementNumberOfTimesUsed();
            }

            //Assert
            Assert.AreEqual(true, myInstrument.Approved);
        }
    }
}
