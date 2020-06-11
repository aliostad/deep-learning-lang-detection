using System.Threading;
using System.Threading.Tasks;
using SEMining.StockData.Models;

namespace SEMining.StockData.DataServices.Trades
{
    public interface IInstrumentService
    {
        void Download(Instrument instrument, CancellationToken cancellationToken);
        void SoftDownload(Instrument instrument, CancellationToken cancellationToken);
        void Delete(Instrument instrument, Task download, CancellationTokenSource cancellationTokenSource);
        bool CheckFiles(Instrument instrument);
    }
}
