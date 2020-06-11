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
    public class Instrument_Update_Test
    {
        Instrument CreateInstrument(ITTInstrumentState instrumentState)
        {
            var orderbook = Substitute.For<ITTOrderBook>();
            instrumentState.Orderbook.Returns(orderbook);
            instrumentState.Alias.Returns("ZNU5");
            return new Instrument(instrumentState);
        }

        [Fact]
        public void EnableBidCxl_Test()
        {
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var instrument = CreateInstrument(instrumentState);

            instrument.EnableBidCxl = false;
            Assert.Equal(instrument.EnableBidCxl, false);

            instrument.EnableBidCxl = true;
            Assert.Equal(instrument.EnableBidCxl, true);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableBidCxl = true;
            Assert.Equal(instrument.EnableBidCxl, true);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableBidCxl = false;
            Assert.Equal(instrument.EnableBidCxl, false);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableBidCxl = false;
            Assert.Equal(instrument.EnableBidCxl, false);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();
        }


        [Fact]
        public void EnableAskCxl_Test()
        {
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var instrument = CreateInstrument(instrumentState);

            instrument.EnableAskCxl = false;
            Assert.Equal(instrument.EnableAskCxl, false);

            instrument.EnableAskCxl = true;
            Assert.Equal(instrument.EnableAskCxl, true);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableAskCxl = true;
            Assert.Equal(instrument.EnableAskCxl, true);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableAskCxl = false;
            Assert.Equal(instrument.EnableAskCxl, false);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableAskCxl = false;
            Assert.Equal(instrument.EnableAskCxl, false);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();
        }


        [Fact]
        public void EnableImpliedCxl_Test()
        {
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var instrument = CreateInstrument(instrumentState);

            instrument.EnableImpliedCxl = false;
            Assert.Equal(instrument.EnableImpliedCxl, false);

            instrument.EnableImpliedCxl = true;
            Assert.Equal(instrument.EnableImpliedCxl, true);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableImpliedCxl = true;
            Assert.Equal(instrument.EnableImpliedCxl, true);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableImpliedCxl = false;
            Assert.Equal(instrument.EnableImpliedCxl, false);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.EnableImpliedCxl = false;
            Assert.Equal(instrument.EnableImpliedCxl, false);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();
        }



        [Fact]
        public void MinImpliedQty_Test()
        {
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var instrument = CreateInstrument(instrumentState);

            instrument.MinImpliedQty = 0;
            Assert.Equal(instrument.MinImpliedQty, 0);

            instrument.MinImpliedQty = 100;
            Assert.Equal(instrument.MinImpliedQty, 100);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.MinImpliedQty = 100;
            Assert.Equal(instrument.MinImpliedQty, 100);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.MinImpliedQty = 0;
            Assert.Equal(instrument.MinImpliedQty, 0);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.MinImpliedQty = 0;
            Assert.Equal(instrument.MinImpliedQty, 0);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();
        }


        [Fact]
        public void BidCxlEdge_Test()
        {
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var instrument = CreateInstrument(instrumentState);

            instrument.BidCxlEdge = 0;
            Assert.Equal((double)instrument.BidCxlEdge, (double)0, 4);

            instrument.BidCxlEdge = (float)0.055;
            Assert.Equal((double)instrument.BidCxlEdge, (double)0.055, 4);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.BidCxlEdge = (float)0.055;
            Assert.Equal((double)instrument.BidCxlEdge, (double)0.055, 4);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.BidCxlEdge = (float)0;
            Assert.Equal((double)instrument.BidCxlEdge, (double)0, 4);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.BidCxlEdge = (float)0;
            Assert.Equal((double)instrument.BidCxlEdge, (double)0, 4);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();
        }



        [Fact]
        public void AskCxlEdge_Test()
        {
            var instrumentState = Substitute.For<ITTInstrumentState>();
            var instrument = CreateInstrument(instrumentState);

            instrument.AskCxlEdge = 0;
            Assert.Equal((double)instrument.AskCxlEdge, (double)0, 4);

            instrument.AskCxlEdge = (float)0.055;
            Assert.Equal((double)instrument.AskCxlEdge, (double)0.055, 4);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.AskCxlEdge = (float)0.055;
            Assert.Equal((double)instrument.AskCxlEdge, (double)0.055, 4);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.AskCxlEdge = (float)0;
            Assert.Equal((double)instrument.AskCxlEdge, (double)0, 4);

            instrument.UpdateIfModified();
            instrumentState.Received(1).InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();

            instrument.AskCxlEdge = (float)0;
            Assert.Equal((double)instrument.AskCxlEdge, (double)0, 4);

            instrument.UpdateIfModified();
            instrumentState.DidNotReceive().InvokeAction(Arg.Any<Action>());
            instrumentState.ClearReceivedCalls();
        }


    }
}
