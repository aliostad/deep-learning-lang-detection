using System;
using BeatsByDre;
using DrumKitUtil;
using NUnit.Framework;

using InstrumentType = BeatsByDre.DrumBeat.InstrumentType;

namespace DrumKitUtilTest
{
    [TestFixture]
    public class Beats
    {
        private DrumBeat _drumBeat;

        [TestFixtureSetUp]
        public void TestFixtureSetup()
        {
            
        }

        [TestFixtureTearDown]
        public void TestFixtureTeardown()
        {

        }

        [SetUp]
        public void Setup()
        {
            _drumBeat = new DrumBeat(InstrumentType.SnareDrum, 1000);
        }

        [Test]
        public void HasInstrumentTest()
        {
            Assert.True(_drumBeat.HasInstrument(), "Drumbeat has no instrument");
        }

        [Test]
        public void ClearInstrumentTest()
        {
            _drumBeat.Clear();
            Assert.False(_drumBeat.HasInstrument(), "Drumbeat has no instrument");
            Assert.AreEqual(_drumBeat.Instrument, InstrumentType.None);
        }

        [Test]
        public void PlayInstrumentTest()
        {
            _drumBeat.Play();
        }

        [Test]
        public void CheckInstrument()
        {
            _drumBeat.Instrument = InstrumentType.Cowbell;
            Assert.AreEqual(_drumBeat.Instrument, InstrumentType.Cowbell);
            Assert.AreNotEqual(_drumBeat.Instrument, InstrumentType.SnareDrum);
        }
    }
}