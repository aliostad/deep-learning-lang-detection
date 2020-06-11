using Midi;
using NUnit.Framework;
using Orphee.CreationShared;
using Orphee.CreationShared.Interfaces;

namespace Orphee.CreationSharedUnitTests.LoopCreationViewModelTests.InstrumentMangerTests
{
    public class InstrumentManagerTestsBase
    {
        protected IInstrumentManager InstrumentManager;

        public InstrumentManagerTestsBase()
        {
            this.InstrumentManager = new InstrumentManager();
        }
    }

    public class WhenTheProgramLoads : InstrumentManagerTestsBase
    {
        
    }

    [TestFixture]
    public class TheInstrumentManagerShouldBeFilled : WhenTheProgramLoads
    {
        [Test]
        public void TheInstrumentManagerShouldNotBeNull()
        {
            Assert.IsNotNull(this.InstrumentManager.InstrumentList);
        }

        [Test]
        public void TheInstrumentManagerShouldNotBeEmpty()
        {
            Assert.IsNotEmpty(this.InstrumentManager.InstrumentList);
        }

        [Test]
        public void TheFirstInstrumentShouldBeTheAccousticGrandPiano()
        {
            Assert.AreEqual(Instrument.AcousticGrandPiano, this.InstrumentManager.InstrumentList[0].Instrument);
        }
    }
}
