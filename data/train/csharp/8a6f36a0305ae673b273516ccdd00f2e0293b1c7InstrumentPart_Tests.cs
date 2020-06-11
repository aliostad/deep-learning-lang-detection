using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LendingLibrary_Library;
using LendingLibrary_Library.MusicSelection;

namespace LendingLibrary_Library_Tests
{
    [TestClass]
    public class InstrumentPart_Tests
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException), "In InstrumentPart Class, constructor.  Argument instrument cannot be null.")]
        public void TestInstrumentPartConstructor_ArgumentInstrumentIsNull_ThrowsArgumentNullException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart(null, 5);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In InstrumentPart Class, constructor.  Argument numberOfCopies must be greater than zero.")]
        public void TestInstrumentPartConstructor_ArgumentNumberOfCopiesIsLessThanZero_ThrowsArgumentException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart(new Instrument("Trombone", true), -1);
        }

        [TestMethod]
        public void TestInstrumentPartConstructorSetsNumberOfCopiesCorrectly()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart(new Instrument("Trombone", true), 5);

            //Assert
            Assert.AreEqual(5, myInstrumentPart.NumberOfCopies);
        }

        [TestMethod]
        public void TestInstrumentPartConstructorSetsInstrumentNameCorrectly()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart(new Instrument("Trombone", true), 5);

            //Assert
            Assert.AreEqual("trombone", myInstrumentPart._Instrument.InstrumentName);
        }

        [TestMethod]
        public void TestInstrumentPartConstructorSetsInstrumentApprovedCorrectly()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart(new Instrument("Trombone", true), 5);

            //Assert
            Assert.AreEqual(true, myInstrumentPart._Instrument.Approved);
        }

        [TestMethod]
        public void TestInstrumentPartConstructorSetsInstrumentNumberOfTimesUsedCorrectly()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            //Note, because false is passed into the constructor of the Instrument as the "createdByAdministrator"
            //parameter, we know this new Instrument was created by a user and thus is actually being used, which 
            //is why numberOfTimesUsed is initially set to one in this case. 
            myInstrumentPart = new InstrumentPart(new Instrument(instrumentName: "Trombone",  createdByAdministrator: false), 5);

            //Assert
            Assert.AreEqual(1, myInstrumentPart._Instrument.NumberOfTimesUsed);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In InstrumentPart Class, method setNumberOfCopies().  Argument number must be greater than zero.")]
        public void TestInstrumentPart_MethodsetNumberOfCopies_ArgumentNumberIsLessThanZero_ThrowsArgumentException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;
            myInstrumentPart = new InstrumentPart(new Instrument("Trombone", true), 5);

            //Act
            myInstrumentPart.setNumberOfCopies(-1);
        }

        [TestMethod]
        public void TestInstrumentPart_MethodSetNumberOfCopies()
        {
            //Arrange
            InstrumentPart myInstrumentPart;
            myInstrumentPart = new InstrumentPart(new Instrument("Trombone", true), 5);

            //Act
            myInstrumentPart.setNumberOfCopies(10);

            //Assert
            Assert.AreEqual(10, myInstrumentPart.NumberOfCopies);
        }
    }
}
