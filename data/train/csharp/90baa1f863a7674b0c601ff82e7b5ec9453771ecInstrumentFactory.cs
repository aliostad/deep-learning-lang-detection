using System.Threading;
using System.Windows.Forms;

namespace MFDExtractor
{
    internal interface IInstrumentFactory
    {
        IInstrument Create(InstrumentType instrumentType);
    }

    class InstrumentFactory : IInstrumentFactory
    {
        private readonly IInstrumentStateSnapshotCache _instrumentStateSnapshotCache;
        private readonly IRendererFactory _rendererFactory;
        private readonly IPerformanceCounterInstanceFactory _performanceCounterInstanceFactory;

        public InstrumentFactory(
            InstrumentStateSnapshotCache instrumentStateSnapshotCache = null, 
            IRendererFactory rendererFactory=null,
            IPerformanceCounterInstanceFactory performanceCounterInstanceFactory = null)
        {
            _instrumentStateSnapshotCache = instrumentStateSnapshotCache ?? new InstrumentStateSnapshotCache();
            _rendererFactory = rendererFactory ?? new RendererFactory();
            _performanceCounterInstanceFactory = performanceCounterInstanceFactory ?? new PerformanceCounterInstanceInstanceFactory();
        }

        public IInstrument Create(InstrumentType instrumentType)
        {
            var renderer = _rendererFactory.CreateRenderer(instrumentType);
            var instrument = new Instrument(_instrumentStateSnapshotCache)
            {
                Type = instrumentType,
                Renderer =renderer,
                RenderedFramesCounter = _performanceCounterInstanceFactory.CreatePerformanceCounterInstance(Application.ProductName, string.Format("Rendered Frames per second - {0}", instrumentType)),
                SkippedFramesCounter = _performanceCounterInstanceFactory.CreatePerformanceCounterInstance(Application.ProductName, string.Format("Skipped Frames per second - {0}", instrumentType)),
                TimeoutFramesCounter = _performanceCounterInstanceFactory.CreatePerformanceCounterInstance(Application.ProductName, string.Format("Timeout Frames per second - {0}", instrumentType)),
                TotalFramesCounter = _performanceCounterInstanceFactory.CreatePerformanceCounterInstance(Application.ProductName, string.Format("Total Frames per second - {0}", instrumentType)),
            };
            return instrument;
        }
    }
}
