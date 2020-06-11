using System;
using NUnit.Framework;
using System.Collections.Generic;

namespace RealtimeInstrumentDataApp.Tests
{
    [TestFixture]
    public class InstrumentTests
    {
        [Test]
        public void AddAnInstrumentAndPrice_ReturnThisAsString()
        {
            // Arrange
            var instrument = new Instrument();
            var expected = "VOD.L: 92.3";

            // Act
            instrument.Name = "VOD.L";
            instrument.Price = 92.3;

            var actual = instrument.ToString();

            // Assert
            Assert.AreEqual(expected, actual);
        }

    }
}
