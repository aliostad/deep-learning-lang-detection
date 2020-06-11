// Licensed under the Apache License, Version 2.0. 
// Copyright (c) Alex Lee. All rights reserved.

namespace SmartQuant
{
    public class OnInstrumentDefinitionEnd : Event
    {
        internal InstrumentDefinitionEnd End { get; private set; }

        public override byte TypeId
        {
            get
            {
                return EventType.OnInstrumentDefintionEnd;
            }
        }

        public OnInstrumentDefinitionEnd(InstrumentDefinitionEnd end)
        {
            this.End = end;
        }
    }
}
