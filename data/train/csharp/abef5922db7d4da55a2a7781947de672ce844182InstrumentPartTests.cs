using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LendingLibrary_Library.MusicSelection;

namespace LendingLibrary_Library_Tests.MusicSelectionTests
{
    [TestClass]
    public class InstrumentPartTests
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException), "In class InstrumentPart, constructor.  String argument instrumentName cannot be null.")]
        public void InstrumentPart_Constructor_StringArgumentInstrumentNameIsNull_ThrowsArgumentNullException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart(null, 1);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class InstrumentPart, constructor.  String argument instrumentName cannot be empty.")]
        public void InstrumentPart_Constructor_StringArgumentInstrumentNameIsEmpty_ThrowsArgumentException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart("", 1);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class InstrumentPart, constructor.  String argument instrumentName cannot be white space.")]
        public void InstrumentPart_Constructor_StringArgumentInstrumentNameIsWhiteSpace_ThrowsArgumentException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart("  ", 1);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class InstrumentPart, constructor.  Int argument numberOfCopies cannot be less than zero.")]
        public void InstrumentPart_Constructor_IntArgumentNumberOfCopiesLessThanZero_ThrowsArgumentException()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart("Flute", -1);
        }

        [TestMethod]
        public void InstrumentPart_Constructor_ClassFieldInstrumentNameCorrectlySet()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart("  Flute ", 1);

            //Assert
            Assert.AreEqual("Flute", myInstrumentPart.InstrumentName);
        }

        [TestMethod]
        public void InstrumentPart_Constructor_ClassFieldInstrumentName_LowerCaseCorrectlySet()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart("  Flute ", 1);

            //Assert
            Assert.AreEqual("flute", myInstrumentPart.InstrumentName_LowerCase);
        }

        [TestMethod]
        public void InstrumentPart_Constructor_ClassFieldNumberOfCopiesCorrectlySet()
        {
            //Arrange
            InstrumentPart myInstrumentPart;

            //Act
            myInstrumentPart = new InstrumentPart("  Flute ", 1);

            //Assert
            Assert.AreEqual(1, myInstrumentPart.NumberOfCopies);
        }
    }
}
