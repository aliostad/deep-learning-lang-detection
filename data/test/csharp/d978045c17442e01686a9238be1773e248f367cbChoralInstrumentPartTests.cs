using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LendingLibrary_Library.MusicSelection;

namespace LendingLibrary_Library_Tests.MusicSelectionTests
{
    [TestClass]
    public class ChoralInstrumentPartTests
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException), "In class ChoralInstrumentPart, constructor.  String argument instrumentName cannot be null.")]
        public void ChoralInstrumentPart_Constructor_StringArgumentInstrumentNameIsNull_ThrowsArgumentNullException()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart(null, 1, true);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class ChoralInstrumentPart, constructor.  String argument instrumentName cannot be empty.")]
        public void ChoralInstrumentPart_Constructor_StringArgumentInstrumentNameIsEmpty_ThrowsArgumentException()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("", 1, true);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class ChoralInstrumentPart, constructor.  String argument instrumentName cannot be white space.")]
        public void ChoralInstrumentPart_Constructor_StringArgumentInstrumentNameIsWhiteSpace_ThrowsArgumentException()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("  ", 1, true);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "In class ChoralInstrumentPart, constructor.  Int argument numberOfCopies cannot be less than zero.")]
        public void ChoralInstrumentPart_Constructor_IntArgumentNumberOfCopiesLessThanZero_ThrowsArgumentException()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("Flute", -1, true);
        }

        [TestMethod]
        public void ChoralInstrumentPart_Constructor_ClassFieldIsChoralCorrectlySet()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("Flute", 8, true);

            //Assert
            Assert.AreEqual(true, myChoralInstrumentPart.IsInChoralScore);
        }

        [TestMethod]
        public void ChoralInstrumentPart_Equals_ArgumentIsEqual()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;
            ChoralInstrumentPart myChoralInstrumentPart2;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("Flute", 8, true);
            myChoralInstrumentPart2 = new ChoralInstrumentPart("Flute", 8, true);

            //Assert
            Assert.AreEqual(true, myChoralInstrumentPart.Equals(myChoralInstrumentPart2));
        }

        [TestMethod]
        public void ChoralInstrumentPart_Equals_ArgumentIsNotEqual()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;
            ChoralInstrumentPart myChoralInstrumentPart2;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("Flute", 8, true);
            myChoralInstrumentPart2 = new ChoralInstrumentPart("Flute", 8, false);

            //Assert
            Assert.AreNotEqual(true, myChoralInstrumentPart.Equals(myChoralInstrumentPart2));
        }

        [TestMethod]
        public void ChoralInstrumentPart_GetHashCode_InstancesAreEqual()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;
            ChoralInstrumentPart myChoralInstrumentPart2;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("Flute", 8, true);
            myChoralInstrumentPart2 = new ChoralInstrumentPart("Flute", 8, true);

            //Assert
            Assert.AreEqual(myChoralInstrumentPart.GetHashCode(), myChoralInstrumentPart2.GetHashCode());
        }

        [TestMethod]
        public void ChoralInstrumentPart_GetHashCode_InstancesAreNotEqual()
        {
            //Arrange
            ChoralInstrumentPart myChoralInstrumentPart;
            ChoralInstrumentPart myChoralInstrumentPart2;

            //Act
            myChoralInstrumentPart = new ChoralInstrumentPart("Flute", 8, true);
            myChoralInstrumentPart2 = new ChoralInstrumentPart("Flute", 8, false);

            //Assert
            Assert.AreNotEqual(myChoralInstrumentPart.GetHashCode(), myChoralInstrumentPart2.GetHashCode());
        }
    }
}
