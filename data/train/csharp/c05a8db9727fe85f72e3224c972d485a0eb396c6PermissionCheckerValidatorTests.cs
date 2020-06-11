// Copyright (c) 2014 Patrick Pulka
// License: https://raw.githubusercontent.com/ermac0/FxConnectProxy/master/LICENSE
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using FxConnectProxy.Validators;

namespace FxConnectProxy.Tests.Validators
{
    [TestClass]
    public class PermissionCheckerValidatorTests
    {
        [TestMethod]
        public void ValidateInstrumentBaseRequest()
        {
            // Null.
            {
                var v = new PermissionCheckerValidator();
                InstrumentBaseRequest r = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                    {
                        v.Validate(r);
                    });
            }

            // Instrument null.
            {
                var v = new PermissionCheckerValidator();
                InstrumentBaseRequest r = new InstrumentBaseRequest();
                r.Instrument = null;

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Instrument empty.
            {
                var v = new PermissionCheckerValidator();
                InstrumentBaseRequest r = new InstrumentBaseRequest();
                r.Instrument = "";

                AssertEx.Throws<ArgumentNullException>(() =>
                {
                    v.Validate(r);
                });
            }

            // Valid
            {
                var v = new PermissionCheckerValidator();
                InstrumentBaseRequest r = new InstrumentBaseRequest();
                r.Instrument = "Test";

                v.Validate(r);
            }
        }
    }
}
