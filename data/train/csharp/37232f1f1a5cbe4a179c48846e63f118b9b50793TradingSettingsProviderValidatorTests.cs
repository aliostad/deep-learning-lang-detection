// Copyright (c) 2014 Patrick Pulka
// License: https://raw.githubusercontent.com/ermac0/FxConnectProxy/master/LICENSE
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using FxConnectProxy.Validators;

namespace FxConnectProxy.Tests.Validators
{
    [TestClass]
    public class TradingSettingsProviderValidatorTests
    {
        [TestMethod]
        public void ValidateInstrumentBaseRequest()
        {
            // Null.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentBaseRequest r = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                    {
                        v.Validate(r);
                    });
            }

            // Instrument null.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentBaseRequest r = new InstrumentBaseRequest();
                r.Instrument = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Instrument empty.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentBaseRequest r = new InstrumentBaseRequest();
                r.Instrument = "";

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Valid.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentBaseRequest r = new InstrumentBaseRequest();
                r.Instrument = "Test";

                v.Validate(r);
            }
        }

        [TestMethod]
        public void ValidateInstrumentAccountBaseRequest()
        {
            // Null.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentAccountBaseRequest r = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                    {
                        v.Validate(r);
                    });
            }

            // Instrument null.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentAccountBaseRequest r = new InstrumentAccountBaseRequest();
                r.Instrument = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Instrument empty.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentAccountBaseRequest r = new InstrumentAccountBaseRequest();
                r.Instrument = "";

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Account null.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentAccountBaseRequest r = new InstrumentAccountBaseRequest();
                r.Instrument = "Test";
                r.Account = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Valid.
            {
                var v = new TradingSettingsProviderValidator();
                InstrumentAccountBaseRequest r = new InstrumentAccountBaseRequest();
                r.Instrument = "Test";
                r.Account = new AccountRow();

                v.Validate(r);
            }
        }
    }
}
