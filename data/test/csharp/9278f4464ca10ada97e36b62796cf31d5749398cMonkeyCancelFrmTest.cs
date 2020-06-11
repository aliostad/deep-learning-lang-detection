using MonkeyCancel;
using System;
using System.Linq;
using Xunit;
using System.Windows.Forms;
using KT_TTAPI;
using ApprovalTests.WinForms;
using NSubstitute;

namespace MonkeyCancelTest.WinFormTests
{
    public class MonkeyCancelFrmTest
    {
        internal static class Helpers
        {
            internal static InstrDef[] CreateListOf4ProductDefs()
            {
                return new InstrDef[]
                {
                    new InstrDef("CME", "ZN", "FUTURE", "Sep15", "ZNU5", "Basic"),
                    new InstrDef("CME", "ZB", "FUTURE", "Sep15", "ZBU5", "Basic"),
                    new InstrDef("CME", "ZF", "FUTURE", "Sep15", "ZFU5", "Basic"),
                    new InstrDef("CME", "ZT", "FUTURE", "Sep15", "ZTU5", "Basic"),
                    new InstrDef("CME", "ZZ", "FUTURE", "Sep15", "ZZU5", "Basic"),
                };
            }


            internal static Instrument CreateInstrumentByAlias(string alias)
            {
                var orderbook = Substitute.For<ITTOrderBook>();
                var instrumentState = Substitute.For<ITTInstrumentState>();
                instrumentState.Orderbook.Returns(orderbook);
                instrumentState.Alias.Returns(alias);
                return new Instrument(instrumentState);
            }

        }


        [Fact]
        public void AddInstrument_DirectOrder()
        {
            using (var form = new MonkeyCancelFrm())
            {
                form.Show();

                form.InstrumentDefinitions = Helpers.CreateListOf4ProductDefs();
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZNU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZBU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZFU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZTU5"));

                WinFormsApprovals.Verify(form.Controls["flowLayoutPanelInstruments"]);
            }
        }


        [Fact]
        public void AddInstrument_ReverseOrder()
        {
            using (var form = new MonkeyCancelFrm())
            {
                form.Show();

                form.InstrumentDefinitions = Helpers.CreateListOf4ProductDefs();
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZTU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZFU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZBU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZNU5"));

                WinFormsApprovals.Verify(form.Controls["flowLayoutPanelInstruments"]);
            }
        }


        [Fact]
        public void AddInstrument_TheFirstArrivedLast()
        {
            using (var form = new MonkeyCancelFrm())
            {
                form.Show();

                form.InstrumentDefinitions = Helpers.CreateListOf4ProductDefs();
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZBU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZFU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZTU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZNU5"));

                WinFormsApprovals.Verify(form.Controls["flowLayoutPanelInstruments"]);
            }
        }


        [Fact]
        public void AddInstrument_TheLastArrivedFirst()
        {
            using (var form = new MonkeyCancelFrm())
            {
                form.Show();

                form.InstrumentDefinitions = Helpers.CreateListOf4ProductDefs();
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZTU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZNU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZBU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZFU5"));

                WinFormsApprovals.Verify(form.Controls["flowLayoutPanelInstruments"]);
            }
        }



        [Fact]
        public void AddInstrument_VerticalScrollBar()
        {
            using (var form = new MonkeyCancelFrm())
            {
                form.Show();

                form.InstrumentDefinitions = Helpers.CreateListOf4ProductDefs();
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZBU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZFU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZTU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZNU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZU5"));

                WinFormsApprovals.Verify(form.Controls["flowLayoutPanelInstruments"]);
            }
        }


        [Fact]
        public void AddInstrument_FormResize()
        {
            using (var form = new MonkeyCancelFrm())
            {
                form.Show();

                form.InstrumentDefinitions = Helpers.CreateListOf4ProductDefs();
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZBU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZFU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZTU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZNU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZU5"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZU6"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZU7"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZU8"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZU9"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZUA"));
                form.AddInstrument(Helpers.CreateInstrumentByAlias("ZZUB"));

                form.Width += 50;
                form.Height += 50;

                WinFormsApprovals.Verify(form);
            }
        }

    }
}