using JetBrains.Annotations;
using Polygon.Messages;

namespace Polygon.Connector
{
    /// <summary>
    ///     Результат подписки на инструмент
    /// </summary>
    [PublicAPI]
    public sealed class SubscriptionResult
    {
        internal SubscriptionResult(Instrument instrument, bool success, string message = "")
        {
            Instrument = instrument;
            Success = success;
            Message = message;
        }

        /// <summary>
        ///     Инструмент
        /// </summary>
        public Instrument Instrument { get; }

        /// <summary>
        ///     Признак успеха
        /// </summary>
        public bool Success { get; }

        /// <summary>
        ///     Сообщение об ошибке
        /// </summary>
        public string Message { get; }

        /// <summary>
        ///     Создать результат, обозначающий успех
        /// </summary>
        public static SubscriptionResult OK(Instrument instrument)
            => new SubscriptionResult(instrument, true);

        /// <summary>
        ///     Создать результат, обозначающий неуспех
        /// </summary>
        public static SubscriptionResult Error(Instrument instrument, string message = "")
            => new SubscriptionResult(instrument, false, message);
    }
}