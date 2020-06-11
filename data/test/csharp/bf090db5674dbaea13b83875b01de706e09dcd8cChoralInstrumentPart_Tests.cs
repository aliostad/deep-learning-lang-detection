using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LendingLibrary_Library.MusicSelection;

namespace LendingLibrary_Library_Tests
{
    [TestClass]
    public class ChoralInstrumentPart_Tests
    {
        [TestMethod]
        public void TestChoralInstrumentPartConstructor_InitialzesFieldIsIncludedInChoralScoreCorrectly()
        {
            //act
            ChoralInstrumentPart myChoralInstrument;
            Instrument myInstrument = new Instrument("Flute", true);

            //arrange
            myChoralInstrument = new ChoralInstrumentPart(myInstrument, 10, true);

            //assert
            Assert.AreEqual(true, myChoralInstrument.IsIncludedInChoralScore);
        }  
    }
}
