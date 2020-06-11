using Polygon.Diagnostics;

namespace Polygon.Connector.QUIKLua.Adapter.Messages
{
    [ObjectName(QLObjectNames.QLInstrumentParamsSubscriptionRequest)]
    internal class QLInstrumentParamsSubscriptionRequest : QLMessage
    {
        public override QLMessageType message_type {get { return QLMessageType.InstrumentParamsSubscriptionRequest;}}
        
        public string instrument { get; set; }

        public QLInstrumentParamsSubscriptionRequest(string instrument)
        {
            this.instrument = instrument;
        }

        public override string Print(PrintOption option)
        {
            var fmt = ObjectLogFormatter.Create(this, option);
            fmt.AddField(LogFieldNames.Instrument, instrument);
            return fmt.ToString();
        }
    }
}

