using System;
using JetBrains.Annotations;
using Polygon.Messages;

namespace Polygon.Connector
{
    /// <summary>
    ///     Аргументы для событий по параметрам инструментов
    /// </summary>
    public sealed class InstrumentParamsEventArgs : EventArgs
    {
        /// <summary>
        ///     Конструктор
        /// </summary>
        /// <param name="instrument">
        ///     Инструмент
        /// </param>
        /// <param name="instrumentParams">
        ///     Параметры инструмента
        /// </param>
        public InstrumentParamsEventArgs([NotNull] Instrument instrument, [NotNull] InstrumentParams instrumentParams)
        {
            Instrument = instrument;
            InstrumentParams = instrumentParams;
        }

        /// <summary>
        ///     Инструмент
        /// </summary>
        [NotNull]
        public Instrument Instrument { get; }

        /// <summary>
        ///     Параметры инструмента
        /// </summary>
        public InstrumentParams InstrumentParams { get; }
    }
}

