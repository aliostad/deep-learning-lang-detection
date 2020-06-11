using System;
using XComponent.Common.ApiContext;
using XComponent.Common.Timeouts;
using XComponent.Referential.Common;
using XComponent.Referential.Common.Senders;
using XComponent.Referential.UserObject;

namespace XComponent.Referential.TriggeredMethod
{
    public static class ReferentialTriggeredMethod
    {
        public static void ExecuteOn_Referential_Through_AddInstrument(XComponent.Referential.UserObject.Instrument instrument, XComponent.Referential.UserObject.InstrumentSnapshot instrumentSnapshot, object object_InternalMember, Context context, IAddInstrumentInstrumentOnReferentialReferentialSenderInterface sender)
        {
            if (!instrumentSnapshot.Instruments.Contains(instrument.Name))
                instrumentSnapshot.Instruments.Add(instrument.Name);
        }
    }
}