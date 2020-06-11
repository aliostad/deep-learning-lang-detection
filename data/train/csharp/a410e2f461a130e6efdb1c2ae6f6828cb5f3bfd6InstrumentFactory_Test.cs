using KT_TTAPI;
using MonkeyCancel;
using NSubstitute;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace MonkeyCancelTest
{
    public class InstrumentFactory_Test
    {
        [Fact]
        public void CreateInstrumetTest_Create_BasicModel_Test()
        {
            var factory = new InstrumentFactory();
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var def = new InstrDef("CME", "ZN", "FUTURE", "Dec15", "ZNZ5", "Basic");
            Instrument instrument = factory.CreateInstrument(def, instrumentState);
            Assert.IsType<Instrument>(instrument);
            Assert.IsNotType<InstrumentSpread>(instrument);
            Assert.IsNotType<InstrumentFutureSpreadImplied>(instrument);
        }


        [Fact]
        public void CreateInstrumetTest_Create_SpreadImpliedModel_Test()
        {
            var factory = new InstrumentFactory();
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var def = new InstrDef("CME", "ZN", "FUTURE", "Dec15", "ZNZ5", "SpreadImplied");
            Instrument instrument = factory.CreateInstrument(def, instrumentState);
            Assert.IsType<InstrumentFutureSpreadImplied>(instrument);
        }


        [Fact]
        public void CreateInstrumetTest_Create_SpreadImpliedNonlinearModel_Test()
        {
            var factory = new InstrumentFactory();
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var def = new InstrDef("CME", "ZN", "FUTURE", "Dec15", "ZNZ5", "SpreadImpliedNonlinear");
            Instrument instrument = factory.CreateInstrument(def, instrumentState);
            Assert.IsType<InstrumentFutureSpreadImplied>(instrument);
        }

        [Fact]
        public void CreateInstrumetTest_Create_Spread_Test()
        {
            var factory = new InstrumentFactory();
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var def = new InstrDef("CME", "ZN", "SPREAD", "CME Reduced Tick Spread: 1xZN Dec15:-1xMar16", "+ZNZ5-ZNH6", "Basic");
            Instrument instrument = factory.CreateInstrument(def, instrumentState);
            Assert.IsType<InstrumentSpread>(instrument);
        }


        [Fact]
        public void CreateInstrumetTest_Create_FlowdownSpread_Test()
        {
            var factory = new InstrumentFactory();
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var def = new InstrDef("CME", "ZN", "SPREAD", "CME Reduced Tick Spread: 1xZN Dec15:-1xMar16", "+ZNZ5-ZNH6", "FlowdownSpread");
            Instrument instrument = factory.CreateInstrument(def, instrumentState);
            Assert.IsType<InstrumentSpreadFlowdown>(instrument);
        }


        [Fact]
        public void CreateInstrumetTest_Create_WrongModel_Test()
        {
            var factory = new InstrumentFactory();
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var def = new InstrDef("CME", "ZN", "FUTURE", "Dec15", "ZNZ5", "");
            Instrument instrument = factory.CreateInstrument(def, instrumentState);
            Assert.IsType<Instrument>(instrument);
            Assert.IsNotType<InstrumentSpread>(instrument);
            Assert.IsNotType<InstrumentFutureSpreadImplied>(instrument);
        }


        [Fact]
        public void CreateInstrumentTest_Build_SpreadBasicPriceModel_Test()
        {
            string seriesZNZ5 = "AAASSSBBBFFFZNZ5";
            string seriesZNH6 = "AAASSSBBBFFFZNH6";

            var factory = Substitute.ForPartsOf<InstrumentFactory>();

            var instrumentStateZNZ5 = Substitute.For<ITTInstrumentState>();
            instrumentStateZNZ5.SpreadType.Returns(TTSpreadType.None);
            instrumentStateZNZ5.Exchange.Returns("CME");
            instrumentStateZNZ5.Series.Returns(seriesZNZ5);
            instrumentStateZNZ5.PointValue.Returns(1000f);
            var defZNZ5 = new InstrDef("CME", "ZN", "FUTURE", "Dec15", "ZNZ5", "Basic");
            Instrument instrumentZNZ5 = Substitute.ForPartsOf<Instrument>(instrumentStateZNZ5);
            factory.CreateBasicOutright(Arg.Is(instrumentStateZNZ5)).Returns(instrumentZNZ5);
            Instrument instrumentZNZ5Returned = factory.CreateInstrument(defZNZ5, instrumentStateZNZ5);
            Assert.Same(instrumentZNZ5, instrumentZNZ5Returned);

            var instrumentStateZNH6 = Substitute.For<ITTInstrumentState>();
            instrumentStateZNH6.SpreadType.Returns(TTSpreadType.None);
            instrumentStateZNH6.Exchange.Returns("CME");
            instrumentStateZNH6.Series.Returns(seriesZNH6);
            instrumentStateZNH6.PointValue.Returns(1000f);
            var defZNH6 = new InstrDef("CME", "ZN", "FUTURE", "Mar16", "ZNH6", "SpreadImplied");
            InstrumentFutureSpreadImplied instrumentZNH6 = Substitute.ForPartsOf<InstrumentFutureSpreadImplied>(instrumentStateZNH6, null, new ArithmeticMeanAggregation());
            factory.CreateSpreadImpliedOutright(Arg.Is(instrumentStateZNH6)).Returns(instrumentZNH6);
            InstrumentFutureSpreadImplied instrumentZNH6Returned = factory.CreateInstrument(defZNH6, instrumentStateZNH6) as InstrumentFutureSpreadImplied; 
            Assert.Same(instrumentZNH6, instrumentZNH6Returned);

            var ttLeg1 = Substitute.For<ITTLeg>();
            ttLeg1.Ratio.Returns(1);
            ttLeg1.Exchange.Returns(defZNZ5.Exchange);
            ttLeg1.Series.Returns(seriesZNZ5);
            ttLeg1.ProductName.Returns(defZNZ5.Product);
            ttLeg1.ProductType.Returns(defZNZ5.ProdType);
            ttLeg1.Expiry.Returns(defZNZ5.Contract);

            var ttLeg2 = Substitute.For<ITTLeg>();
            ttLeg2.Ratio.Returns(-1);
            ttLeg2.Exchange.Returns(defZNH6.Exchange);
            ttLeg2.Series.Returns(seriesZNH6);
            ttLeg2.ProductName.Returns(defZNH6.Product);
            ttLeg2.ProductType.Returns(defZNH6.ProdType);
            ttLeg2.Expiry.Returns(defZNH6.Contract);

            var instrumentStateSpread = Substitute.For<ITTInstrumentState>();
            instrumentStateSpread.Legs.Returns(new ITTLeg[] { ttLeg1, ttLeg2 });
            instrumentStateSpread.SpreadType.Returns(TTSpreadType.ReducedTickSpread);
            instrumentStateSpread.Exchange.Returns("CME");
            var defSpread = new InstrDef("CME", "ZN", "SPREAD", "CME Reduced Tick Spread: 1xZN Dec15:-1xMar16", "+ZNZ5-ZNH6", "Basic");
            InstrumentSpread instrumentSpread = Substitute.ForPartsOf<InstrumentSpread>(instrumentStateSpread);
            factory.CreateSpreadInstrument(Arg.Is(instrumentStateSpread)).Returns(instrumentSpread);
            InstrumentSpread instrumentSpreadReturned = factory.CreateInstrument(defSpread, instrumentStateSpread) as InstrumentSpread;
            Assert.Same(instrumentSpread, instrumentSpreadReturned);

            factory.UpdateInstrument(instrumentStateSpread);
            Assert.NotNull(instrumentSpread.Legs);
            Assert.Equal(instrumentSpread.Legs.Length, 2);

            Assert.Equal(instrumentSpread.Legs[0].Instrument, instrumentZNZ5);
            Assert.Equal(instrumentSpread.Legs[0].Ratio, 1);
            Assert.Equal(instrumentSpread.Legs[0].Weight, 1f, 5);

            Assert.Equal(instrumentSpread.Legs[1].Instrument, instrumentZNH6);
            Assert.Equal(instrumentSpread.Legs[1].Ratio, -1);
            Assert.Equal(instrumentSpread.Legs[1].Weight, -1f, 5);

            Assert.False(instrumentSpread.IsNetChangePx);

            instrumentZNZ5.OnPriceChanged += Raise.Event();
            instrumentZNH6.Received(1).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
            instrumentZNH6.ClearReceivedCalls();

            instrumentZNZ5.OnPriceChanged += Raise.Event();
            instrumentSpread.OnPriceChanged += Raise.Event();
            instrumentZNH6.Received(2).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
        }


        [Fact]
        public void CreateInstrumentTest_Build_SpreadFlowdownPriceModel_Test()
        {
            string seriesZNZ5 = "AAASSSBBBFFFZNZ5";
            string seriesZNH6 = "AAASSSBBBFFFZNH6";

            var factory = Substitute.ForPartsOf<InstrumentFactory>();

            var instrumentStateZNZ5 = Substitute.For<ITTInstrumentState>();
            instrumentStateZNZ5.SpreadType.Returns(TTSpreadType.None);
            instrumentStateZNZ5.Exchange.Returns("CME");
            instrumentStateZNZ5.Series.Returns(seriesZNZ5);
            instrumentStateZNZ5.PointValue.Returns(1000f);
            var defZNZ5 = new InstrDef("CME", "ZN", "FUTURE", "Dec15", "ZNZ5", "Basic");
            Instrument instrumentZNZ5 = Substitute.ForPartsOf<Instrument>(instrumentStateZNZ5);
            factory.CreateBasicOutright(Arg.Is(instrumentStateZNZ5)).Returns(instrumentZNZ5);
            Instrument instrumentZNZ5Returned = factory.CreateInstrument(defZNZ5, instrumentStateZNZ5);
            Assert.Same(instrumentZNZ5, instrumentZNZ5Returned);

            var instrumentStateZNH6 = Substitute.For<ITTInstrumentState>();
            instrumentStateZNH6.SpreadType.Returns(TTSpreadType.None);
            instrumentStateZNH6.Exchange.Returns("CME");
            instrumentStateZNH6.Series.Returns(seriesZNH6);
            instrumentStateZNH6.PointValue.Returns(1000f);
            var defZNH6 = new InstrDef("CME", "ZN", "FUTURE", "Mar16", "ZNH6", "SpreadImplied");
            InstrumentFutureSpreadImplied instrumentZNH6 = Substitute.ForPartsOf<InstrumentFutureSpreadImplied>(instrumentStateZNH6, null, new ArithmeticMeanAggregation());
            factory.CreateSpreadImpliedOutright(Arg.Is(instrumentStateZNH6)).Returns(instrumentZNH6);
            InstrumentFutureSpreadImplied instrumentZNH6Returned = factory.CreateInstrument(defZNH6, instrumentStateZNH6) as InstrumentFutureSpreadImplied;
            Assert.Same(instrumentZNH6, instrumentZNH6Returned);

            var ttLeg1 = Substitute.For<ITTLeg>();
            ttLeg1.Ratio.Returns(1);
            ttLeg1.Exchange.Returns(defZNZ5.Exchange);
            ttLeg1.Series.Returns(seriesZNZ5);
            ttLeg1.ProductName.Returns(defZNZ5.Product);
            ttLeg1.ProductType.Returns(defZNZ5.ProdType);
            ttLeg1.Expiry.Returns(defZNZ5.Contract);

            var ttLeg2 = Substitute.For<ITTLeg>();
            ttLeg2.Ratio.Returns(-1);
            ttLeg2.Exchange.Returns(defZNH6.Exchange);
            ttLeg2.Series.Returns(seriesZNH6);
            ttLeg2.ProductName.Returns(defZNH6.Product);
            ttLeg2.ProductType.Returns(defZNH6.ProdType);
            ttLeg2.Expiry.Returns(defZNH6.Contract);

            var instrumentStateSpread = Substitute.For<ITTInstrumentState>();
            instrumentStateSpread.Legs.Returns(new ITTLeg[] { ttLeg1, ttLeg2 });
            instrumentStateSpread.SpreadType.Returns(TTSpreadType.ReducedTickSpread);
            instrumentStateSpread.Exchange.Returns("CME");
            var defSpread = new InstrDef("CME", "ZN", "SPREAD", "CME Reduced Tick Spread: 1xZN Dec15:-1xMar16", "+ZNZ5-ZNH6", "FlowdownSpread");
            InstrumentSpreadFlowdown instrumentSpread = Substitute.ForPartsOf<InstrumentSpreadFlowdown>(instrumentStateSpread);
            factory.CreateFlowdownSpreadInstrument(Arg.Is(instrumentStateSpread)).Returns(instrumentSpread);
            InstrumentSpreadFlowdown instrumentSpreadReturned = factory.CreateInstrument(defSpread, instrumentStateSpread) as InstrumentSpreadFlowdown;
            Assert.Same(instrumentSpread, instrumentSpreadReturned);

            factory.UpdateInstrument(instrumentStateSpread);
            Assert.NotNull(instrumentSpread.Legs);
            Assert.Equal(instrumentSpread.Legs.Length, 2);

            Assert.Equal(instrumentSpread.Legs[0].Instrument, instrumentZNZ5);
            Assert.Equal(instrumentSpread.Legs[0].Ratio, 1);
            Assert.Equal(instrumentSpread.Legs[0].Weight, 1f, 5);

            Assert.Equal(instrumentSpread.Legs[1].Instrument, instrumentZNH6);
            Assert.Equal(instrumentSpread.Legs[1].Ratio, -1);
            Assert.Equal(instrumentSpread.Legs[1].Weight, -1f, 5);

            Assert.False(instrumentSpread.IsNetChangePx);

            instrumentZNZ5.OnPriceChanged += Raise.Event();
            instrumentSpread.Received(1).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
            instrumentSpread.ClearReceivedCalls();

            instrumentZNH6.OnPriceChanged += Raise.Event();
            instrumentSpread.Received(1).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
            instrumentSpread.ClearReceivedCalls();

            instrumentZNZ5.OnPriceChanged += Raise.Event();
            instrumentSpread.Received(1).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
            instrumentZNH6.OnPriceChanged += Raise.Event();
            instrumentSpread.Received(2).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
            instrumentSpread.OnPriceChanged += Raise.Event();
            instrumentSpread.Received(2).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
        }


        [Fact]
        public void CreateInstrumentTest_Build_IcsSpread_Test()
        {
            string seriesZTZ5 = "AAASSSBBBFFFZTZ5";
            string seriesZNZ5 = "AAASSSBBBFFFZNZ5";

            var factory = Substitute.ForPartsOf<InstrumentFactory>();

            var instrumentStateZTZ5 = Substitute.For<ITTInstrumentState>();
            instrumentStateZTZ5.SpreadType.Returns(TTSpreadType.None);
            instrumentStateZTZ5.Exchange.Returns("CME");
            instrumentStateZTZ5.Series.Returns(seriesZTZ5);
            instrumentStateZTZ5.PointValue.Returns(2000f);
            var defZTZ5 = new InstrDef("CME", "ZT", "FUTURE", "Dec15", "ZTZ5", "Basic");
            Instrument instrumentZTZ5 = Substitute.ForPartsOf<Instrument>(instrumentStateZTZ5);
            factory.CreateBasicOutright(Arg.Is(instrumentStateZTZ5)).Returns(instrumentZTZ5);
            Instrument instrumentZTZ5Returned = factory.CreateInstrument(defZTZ5, instrumentStateZTZ5);
            Assert.Same(instrumentZTZ5, instrumentZTZ5Returned);

            var instrumentStateZNZ5 = Substitute.For<ITTInstrumentState>();
            instrumentStateZNZ5.SpreadType.Returns(TTSpreadType.None);
            instrumentStateZNZ5.Exchange.Returns("CME");
            instrumentStateZNZ5.Series.Returns(seriesZNZ5);
            instrumentStateZNZ5.PointValue.Returns(1000f);
            var defZNZ5 = new InstrDef("CME", "ZN", "FUTURE", "Dec16", "ZNZ5", "SpreadImplied");
            InstrumentFutureSpreadImplied instrumentZNZ5 = Substitute.ForPartsOf<InstrumentFutureSpreadImplied>(instrumentStateZNZ5, null, new ArithmeticMeanAggregation());
            factory.CreateSpreadImpliedOutright(Arg.Is(instrumentStateZNZ5)).Returns(instrumentZNZ5);
            InstrumentFutureSpreadImplied instrumentNZ5Returned = factory.CreateInstrument(defZNZ5, instrumentStateZNZ5) as InstrumentFutureSpreadImplied;
            Assert.Same(instrumentZNZ5, instrumentNZ5Returned);

            var ttLeg1 = Substitute.For<ITTLeg>();
            ttLeg1.Ratio.Returns(9);
            ttLeg1.Exchange.Returns(defZTZ5.Exchange);
            ttLeg1.Series.Returns(seriesZTZ5);
            ttLeg1.ProductName.Returns(defZTZ5.Product);
            ttLeg1.ProductType.Returns(defZTZ5.ProdType);
            ttLeg1.Expiry.Returns(defZTZ5.Contract);

            var ttLeg2 = Substitute.For<ITTLeg>();
            ttLeg2.Ratio.Returns(-5);
            ttLeg2.Exchange.Returns(defZNZ5.Exchange);
            ttLeg2.Series.Returns(seriesZNZ5);
            ttLeg2.ProductName.Returns(defZNZ5.Product);
            ttLeg2.ProductType.Returns(defZNZ5.ProdType);
            ttLeg2.Expiry.Returns(defZNZ5.Contract);

            var instrumentStateSpread = Substitute.For<ITTInstrumentState>();
            instrumentStateSpread.SpreadType.Returns(TTSpreadType.Ics);
            instrumentStateSpread.Exchange.Returns("CME");
            instrumentStateSpread.Legs.Returns(new ITTLeg[] { ttLeg1, ttLeg2 });
            var defSpread = new InstrDef("CME", "ZTZN", "SPREAD", "ICS: 9xZT Dec15:-5xZN Dec15,+9ZTZ5 - 5ZNZ5", "+9ZTZ5-5ZNZ5", "Basic");
             InstrumentSpread instrumentSpread = Substitute.ForPartsOf<InstrumentSpread>(instrumentStateSpread);
            factory.CreateSpreadInstrument(Arg.Is(instrumentStateSpread)).Returns(instrumentSpread);
            InstrumentSpread instrumentSpreadReturned = factory.CreateInstrument(defSpread, instrumentStateSpread) as InstrumentSpread;
            Assert.Same(instrumentSpread, instrumentSpreadReturned);

            factory.UpdateInstrument(instrumentStateZNZ5);
            Assert.Null(instrumentSpread.Legs);

            factory.UpdateInstrument(instrumentStateZTZ5);
            Assert.Null(instrumentSpread.Legs);

            factory.UpdateInstrument(instrumentStateSpread);
            Assert.NotNull(instrumentSpread.Legs);
            Assert.Equal(instrumentSpread.Legs.Length, 2);

            Assert.Equal(instrumentSpread.Legs[0].Instrument, instrumentZTZ5);
            Assert.Equal(instrumentSpread.Legs[0].Ratio, 9);
            Assert.Equal(instrumentSpread.Legs[0].Weight, 9f * 2, 5);

            Assert.Equal(instrumentSpread.Legs[1].Instrument, instrumentZNZ5);
            Assert.Equal(instrumentSpread.Legs[1].Ratio, -5);
            Assert.Equal(instrumentSpread.Legs[1].Weight, -5f * 1);

            Assert.True(instrumentSpread.IsNetChangePx);

            instrumentZTZ5.OnPriceChanged += Raise.Event();
            instrumentZNZ5.Received(1).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
            instrumentZNZ5.ClearReceivedCalls();

            instrumentZTZ5.OnPriceChanged += Raise.Event();
            instrumentSpread.OnPriceChanged += Raise.Event();
            instrumentZNZ5.Received(2).OnLinkedInstrumentChanged(Arg.Any<object>(), Arg.Any<EventArgs>());
        }


    }
}
