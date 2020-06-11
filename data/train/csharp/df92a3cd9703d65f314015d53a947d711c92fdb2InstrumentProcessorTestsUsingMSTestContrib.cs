using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace KataInstrumentProcessor.Tests
{
    using MSTestContrib.Specifications;

    using Moq;

    [TestClass]
    [SpecificationDescription("InstrumentProcessor")]
    public class InstrumentProcessorTestsUsingMSTestContrib : Specification
    {
        private Mock<IInstrument> instrument;
        private Mock<ITaskDispatcher> taskDispatcher;

        private InstrumentProcessor instrumentProcessor;

        [TestMethod]
        [ScenarioDescription("Create class.")]
        public void CreateInstrumentProcessor()
        {
            this.Given("I have an instrument", context => { this.instrument = new Mock<IInstrument>(); })
                .And("I have an task dispatcher", context => { taskDispatcher = new Mock<ITaskDispatcher>(); })
                .When("I create an instrument processor", context => { instrumentProcessor = new InstrumentProcessor(this.instrument.Object, taskDispatcher.Object, new Mock<IConsole>().Object); })
                .Then("I get a valid instance.", context => this.instrumentProcessor != null);
        }
    }
}
