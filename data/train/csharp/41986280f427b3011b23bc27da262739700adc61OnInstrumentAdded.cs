// Licensed under the Apache License, Version 2.0. 
// Copyright (c) Alex Lee. All rights reserved.

namespace SmartQuant
{
    public class OnInstrumentAdded : Event
    {
        internal Instrument Instrument { get; private set; }

        public override byte TypeId
        {
            get
            {
                return EventType.OnInstrumentAdded;
            }
        }

        public OnInstrumentAdded(Instrument instrument)
        {
            this.Instrument = instrument;
        }
    }
}
