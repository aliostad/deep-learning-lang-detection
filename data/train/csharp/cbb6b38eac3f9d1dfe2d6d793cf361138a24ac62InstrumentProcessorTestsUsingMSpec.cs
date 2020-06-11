using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace KataInstrumentProcessor.Tests
{
    using Machine.Specifications;

    using Moq;

    using It = Machine.Specifications.It;

    [TestClass]
    public class InstrumentProcessorTestsUsingMSpec
    {
        private Mock<IInstrument> instrument;
        private Mock<ITaskDispatcher> taskDispatcher;
        private InstrumentProcessor instrumentProcessor;

        [TestMethod]
        public void TestMethod1()
        {
            Establish context = () =>
                {
                    instrument = new Mock<IInstrument>();
                    taskDispatcher = new Mock<ITaskDispatcher>();
                };

            Because of = () =>
                this.instrumentProcessor = new InstrumentProcessor(this.instrument.Object, this.taskDispatcher.Object, new Mock<IConsole>().Object);
            It should_give_a_valid_instance = () => Assert.IsNull(this.instrumentProcessor);
        }
    }
}
