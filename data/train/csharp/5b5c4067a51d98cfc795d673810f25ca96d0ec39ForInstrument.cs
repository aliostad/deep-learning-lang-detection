using FizzWare.NBuilder;
using FluentAssertions;
using MRDC.Data;
using NUnit.Framework;

namespace MRDC.Tests.MarketDataTests.FollowingErrorsShouldBeCaught {
    [TestFixture]
    public class ForInstrument {
        private MarketData marketData;

        [SetUp]
        public void Init() {
            var instrument = Builder<Instrument>.CreateNew()
                                                .With(x => x.InstrumentId = 1)
                                                .Build();
            marketData = Builder<MarketData>.CreateNew()
                                            .With(x => x.Instrument = instrument)
                                            .Build();

            marketData.SelfValidate()
                      .Result
                      .Should()
                      .BeTrue("Everything is ok according to types and rules");
        }

        [Test]
        public void InstrumentMissing() {
            // arrange 
            marketData.Instrument = null;

            // assert
            var validation = marketData.SelfValidate();
            validation.Result
                      .Should()
                      .BeFalse("Instrument was set to null");

            validation.ErrorMessage
                      .Should()
                      .Be("Instrument is null. ");
        }

        [Test]
        public void InstrumentIsEmpty() {
            // arrange 
            marketData.Instrument = new Instrument();

            // assert
            var validation = marketData.SelfValidate();
            validation.Result
                      .Should()
                      .BeFalse("Instrument is not initialized");

            validation.ErrorMessage
                      .Should()
                      .Be("Instrument is not initizlized, because InstrumentId should be positive number. Name for the instrument was not provided. ");
        }

        [Test]
        [TestCase("")]
        [TestCase("   ")]
        [TestCase("\t")]
        [TestCase("\r\n")]
        [TestCase(null)]
        public void NameIsMissed(string instrumentName) {
            // arrange 
            marketData.Instrument.Name = instrumentName;

            // assert
            var validation = marketData.SelfValidate();
            validation.Result
                      .Should()
                      .BeFalse("Instrument is not initialized");

            validation.ErrorMessage
                      .Should()
                      .Be("Name for the instrument was not provided. ");
        }
    }
}
