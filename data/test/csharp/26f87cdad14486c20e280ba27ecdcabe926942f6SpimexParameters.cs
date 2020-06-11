namespace Polygon.Connector.Spimex
{
    public sealed class SpimexParameters : IConnectorFactory
    {
        public SpimexParameters(
            CommClientSettings infoClientSettings,
            CommClientSettings transClientSettings,
            InstrumentConverter<SpimexInstrumentData> instrumentConverter)
        {
            InfoClientSettings = infoClientSettings;
            TransClientSettings = transClientSettings;
            InstrumentConverter = instrumentConverter;
        }

        public CommClientSettings InfoClientSettings { get; }
        public CommClientSettings TransClientSettings { get; }
        public InstrumentConverter<SpimexInstrumentData> InstrumentConverter { get; }

        /// <summary>
        ///     Создать транспорт
        /// </summary>
        public IConnector CreateConnector()
        {
            return new SpimexConnector(InfoClientSettings,TransClientSettings, InstrumentConverter);
        }
    }
}