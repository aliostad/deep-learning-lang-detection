// Licensed under the Apache License, Version 2.0. 
// Copyright (c) Alex Lee. All rights reserved.

namespace SmartQuant
{
    public class OnInstrumentDefinition : Event
    {
        internal InstrumentDefinition Definition { get; private set; }

        public override byte TypeId
        {
            get
            {
                return EventType.OnInstrumentDefinition;
            }
        }

        public OnInstrumentDefinition(InstrumentDefinition definition)
        {
            this.Definition = definition;
        }
    }
}
