using NUnit.Framework;
using MidiGremlin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NSubstitute;
using NSubstitute.Core;
using NUnit.Framework.Constraints;

namespace MidiGremlin.Tests
{
    [TestFixture]
    public class OrchestraTests
    {

        [Test]
        [TestCase(InstrumentType.Violin, 5)]
        public void AddInstrumentTest(InstrumentType instrumentType, int octave = 3)
        {
            Orchestra orc = new Orchestra(Substitute.For<IMidiOut>(), 8);
            orc.AddInstrument(instrumentType, octave);

            bool test = orc.Instruments.ToList().Exists(item => (item.InstrumentType == instrumentType) && (item.Octave == octave));


            Assert.IsTrue(test);
        }

        [Test]
        public void AddInstrumentTest1()
        {
            Scale scale = new Scale(Tone.A, Tone.B, Tone.C);
            Orchestra orc = new Orchestra(Substitute.For<IMidiOut>(), 8);
            orc.AddInstrument(InstrumentType.Violin, scale, 5);

            bool test = orc.Instruments.ToList().Exists(item => (item.InstrumentType == InstrumentType.Violin) && (item.Octave == 5) && (item.Scale == scale));


            Assert.IsTrue(test);
        }
    }
}