using System.Collections.Concurrent;
using System.Threading.Tasks;
using JetBrains.Annotations;
using Polygon.Messages;

namespace Polygon.Connector
{
    /// <summary>
    ///     Конвертер для инструментов и их метаданных
    /// </summary>
    /// <typeparam name="T">
    ///     Тип метаданных инструмента
    /// </typeparam>
    [PublicAPI]
    public abstract class InstrumentConverter<T>
        where T : InstrumentData
    {
        #region Преобразование Symbol -> Instrument

        private readonly ConcurrentDictionary<string, Instrument> _instrumentBySymbol = new ConcurrentDictionary<string, Instrument>();

        /// <summary>
        ///     Разрешить инструмент по вендорскому коду
        /// </summary>
        /// <param name="context">
        ///     Контекст
        /// </param>
        /// <param name="symbol">
        ///     Вендорский код
        /// </param>
        /// <param name="dependentObjectDescription">
        ///     Строковое описание объекта, который зависит от инструмента
        /// </param>
        [NotNull, ItemCanBeNull]
        public async Task<Instrument> ResolveSymbolAsync(
            IInstrumentConverterContext<T> context,
            string symbol,
            string dependentObjectDescription = null)
        {
            if (_instrumentBySymbol.TryGetValue(symbol, out var instrument))
            {
                return instrument;
            }

            instrument = await ResolveSymbolImplAsync(context, symbol, dependentObjectDescription);
            if (instrument == null)
            {
                return null;
            }

            _instrumentBySymbol.TryAdd(symbol, instrument);

            return instrument;
        }

        /// <summary>
        ///     Разрешить инструмент по вендорскому коду
        /// </summary>
        [NotNull, ItemCanBeNull]
        protected abstract Task<Instrument> ResolveSymbolImplAsync(
            IInstrumentConverterContext<T> context,
            string symbol,
            string dependentObjectDescription);

        #endregion

        #region Преобразование Instrument -> Metadata

        private readonly ConcurrentDictionary<Instrument, T> _instrumentDataByInstrument = new ConcurrentDictionary<Instrument, T>();

        /// <summary>
        ///     Получить символ по инструменту
        /// </summary>
        /// <param name="context">
        ///     Контекст
        /// </param>
        /// <param name="instrument">
        /// </param>
        /// <param name="isTestVendorCodeRequired">
        ///     Флаг выполнения тестирования вендорского кода через адаптер транспорта
        /// </param>
        /// <returns>
        ///     Асихронный результат с вендорским кодом инструмента
        /// </returns>
        [NotNull, ItemCanBeNull]
        public async Task<T> ResolveInstrumentAsync(
            IInstrumentConverterContext<T> context,
            Instrument instrument,
            bool isTestVendorCodeRequired = false)
        {
            if (_instrumentDataByInstrument.TryGetValue(instrument, out var data))
            {
                return data;
            }

            data = await ResolveInstrumentImplAsync(context, instrument, isTestVendorCodeRequired);
            if (data == null)
            {
                return null;
            }

            if (isTestVendorCodeRequired)
            {
                var tester = context.SubscriptionTester;
                if (tester != null)
                {
                    var result = await tester.TestSubscriptionAsync(data);
                    if (!result.Ok)
                    {
                        return null;
                    }
                }
            }
            
            _instrumentDataByInstrument.TryAdd(instrument, data);

            return data;
        }

        /// <summary>
        ///     Разрешить инструмент по вендорскому коду
        /// </summary>
        [NotNull, ItemCanBeNull]
        protected abstract Task<T> ResolveInstrumentImplAsync(
            IInstrumentConverterContext<T> context,
            Instrument instrument,
            bool isTestVendorCodeRequired);

        #endregion
    }
}
