// Copyright (c) FastQuant Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;

namespace FastQuant
{
    public class InstrumentServer : IDisposable
    {
        protected Framework framework;
        protected InstrumentList instruments = new InstrumentList();

        public InstrumentServer(Framework framework)
        {
            this.framework = framework;
        }

        public void Dispose()
        {
            Close();
        }

        public virtual void Open()
        {
        }

        public virtual void Flush()
        {
        }

        public virtual void Close()
        {
        }

        public virtual void Delete(Instrument instrument)
        {
        }

        public virtual InstrumentList Load() => this.instruments;

        public virtual void Save(Instrument instrument)
        {
        }
    }
}