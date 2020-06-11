using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Practices.ObjectBuilder2;
using Microsoft.Practices.Unity;
using SEMining.Commons.Info;
using SEMining.Commons.Sistem;
using SEMining.StockData.Models;
using SEMining.StockData.Holders;
using SE_mining_base.Info.Message;

namespace SEMining.StockData.DataServices.Trades.Finam
{
    public class FinamInstrumentService : IInstrumentService
    {
        private readonly IInstrumentSplitter _instrumentSplitter;
        private readonly IFileManager _fileManager;
        private readonly IInfoPublisher _infoPublisher;

        public FinamInstrumentService()
        {
            _instrumentSplitter = ContainerBuilder.Container.Resolve<IInstrumentSplitter>();
            _fileManager = ContainerBuilder.Container.Resolve<IFileManager>();
            _infoPublisher = ContainerBuilder.Container.Resolve<IInfoPublisher>();
           
        }
        // Finam can return data only synchronously
        public void Download(Instrument instrument, CancellationToken cancellationToken)
        {
            DeleteFolder(instrument);
            CreateFolder(instrument);

            _instrumentSplitter.Split(instrument).ForEach(i =>
            {
                if (cancellationToken.IsCancellationRequested)
                {
                    return;
                }
                var downloader = ContainerBuilder.Container.Resolve<ITradesDownloader>();
                downloader.Download(i);
                _infoPublisher.PublishInfo(new DownloadInfo { Message = i + "- was downloaded" });
            });
        }

        public void SoftDownload(Instrument instrument, CancellationToken cancellationToken)
        {
            CreateFolder(instrument);

            _instrumentSplitter.Split(instrument).ForEach(i =>
            {
                if (cancellationToken.IsCancellationRequested || FileExist(i))
                {
                    return;
                }
                var downloader = ContainerBuilder.Container.Resolve<ITradesDownloader>();
                downloader.Download(i);
                _infoPublisher.PublishInfo(new DownloadInfo { Message = i + "- was soft downloaded" });
            });
        }

        public void Delete(Instrument instrument, Task download, CancellationTokenSource cancellationTokenSource)
        {
            if (download != null && !download.IsCompleted)
            {
                _infoPublisher.PublishInfo(new DownloadInfo { Message = instrument + "- cancellation will wait till download task will finish" });
                cancellationTokenSource.Cancel();
                download.Wait();
            }
            DeleteFolder(instrument);
            var instrumentsHolder = ContainerBuilder.Container.Resolve<IDownloadedInstrumentsHolder>();
            instrumentsHolder.Remove(instrument);
            _infoPublisher.PublishInfo(new DownloadInfo { Message = instrument + "- is deleted" });
        }

        public bool CheckFiles(Instrument instrument)
        {
            return _fileManager.IsDirectoryExist(instrument.DataProvider + "\\" + instrument.Path) &&
                _instrumentSplitter.Split(instrument).All(FileExist);
        }

        private bool FileExist(Instrument instrument)
        {
            return _fileManager.IsFileExist(instrument.DataProvider + "\\" + instrument.Path + "\\" + instrument.FileName + ".txt");
        }

        private void DeleteFolder(Instrument instrument)
        {
            _fileManager.DeleteFolder(instrument.DataProvider + "\\" + instrument.Path);
        }

        private void CreateFolder(Instrument instrument)
        {
            _fileManager.CreateFolder(instrument.DataProvider + "\\" + instrument.Path);
        }
    }
}
