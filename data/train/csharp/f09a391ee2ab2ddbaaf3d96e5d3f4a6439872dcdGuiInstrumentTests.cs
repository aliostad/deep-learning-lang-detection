using System.Collections.Generic;
using NUnit.Framework;

namespace RealtimeInstrumentDataApp.Tests
{
    [TestFixture]
    public class GuiInstrumentTests
    {
        private GuiInstrument _guiInstrument;
        private List<double> _prices;

        [SetUp]
        public void InitialSetup()
        {
            _guiInstrument = new GuiInstrument();
            _guiInstrument.Prices = new List<double>();
            _prices = new List<double>()
            {
                15.0,
                16.3,
                17.8,
                25.2,
                14.5
            };

            foreach (var price in _prices)
            {
                _guiInstrument.AddPrice(price);
            }
        }

        [Test]
        public void SetInstrumentName_RetrieveNameFromGuiInstrument()
        {
            // Arrange
            var expected = "VOD.L";

            // Act
            _guiInstrument.Name = "VOD.L";

            // Assert
            Assert.AreEqual(expected, _guiInstrument.Name);
        }

        [Test]
        public void SetInstrumentPrices_RetrievePricesFromGuiIntrument_TestAddPriceMethod()
        {
            // Arrange
            var expected = _prices;

            // Act           
            var actual = _guiInstrument.Prices;

            // Assert
            CollectionAssert.AreEqual(expected, actual);
        }

        [Test]
        public void SetInstrumentPrices_RetrieveAveragePrice5DaysFromGuiInstrument()
        {
            // Arrange
            var expected = 17.76;

            // Act
            var actual = _guiInstrument.AverageOver5Prices;

            // Assert
            Assert.AreEqual(expected, actual);
        }
    }
}
