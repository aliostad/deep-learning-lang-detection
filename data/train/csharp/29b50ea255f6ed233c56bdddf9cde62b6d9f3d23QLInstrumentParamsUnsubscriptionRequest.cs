using Polygon.Diagnostics;

namespace Polygon.Connector.QUIKLua.Adapter.Messages
{
    [ObjectName(QLObjectNames.QLInstrumentParamsUnsubscriptionRequest)]
    class QLInstrumentParamsUnsubscriptionRequest : QLMessage
    {
        public override QLMessageType message_type {get { return QLMessageType.InstrumentParamsUnsubscriptionRequest;}}

        public string instrument { get; set; }

        public QLInstrumentParamsUnsubscriptionRequest(string instrument)
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

