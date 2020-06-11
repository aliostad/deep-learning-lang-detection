
using System.Configuration;
using vincontrol.StockingGuide.Repository.Repositories;

namespace vincontrol.StockingGuide.Repository.Interfaces {
    public interface IVincontrolUnitOfWork {
        IWeeklyTurnOverRepository WeeklyTurnOverRepository { get; }
        IInventoryRepository InventoryRepository { get; }
        ISoldInventoryRepository SoldInventoryRepository { get; }
        IAppraisalRepository AppraisalRepository { get; }
        IVehicleRepository VehicleRepository { get; }
        IModelRepository ModelRepository { get; }
        IDealerBrandRepository DealerBrandRepository { get; }
        IDealerBrandSelectionRepository DealerBrandSelectionRepository { get; }
        ISegmentRepository SegmentRepository { get; }
        IInventorySegmentDetailRepository InventorySegmentDetailRepository { get; }
        IDealerSegmentRepository DealerSegmentRepository { get; }
        IMarketSegmentDetailRepository MarketSegmentDetailRepository { get; }
        IDealerRepository DealerRepository { get; }
        ISettingRepository SettingRepository { get; }
        ITrimRepository TrimRepository { get; }
        IDataDealerExportRepository ExportRepository { get; }

        void Commit();
    }

}