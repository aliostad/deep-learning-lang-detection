using AutoGestDAL.Interfaces;

namespace AutoGestDAL.Implementation
{
    public interface IRepositoryAggregator
    {
        ICategoryServiceRepository CategoryService { get; }
        IClientRepository Client { get; }
        IClosetRepository ClosetRepository { get; }
        ICompanyRepository CompanyRepository { get; }
        IDetailsOrderRepairRepository DetailsOrderRepairRepository { get; }
        IEmployeeRepository EmployeeRepository { get; }
        IHallRepository HallRepository { get; }
        IMarkRepository MarkRepository { get; }
        IModelRepository ModelRepository { get; }
        IOrderRepairRepository OrderRepair { get; }
        IProductRepository ProductRepository { get; }
        IProductVersionRepository ProductVersionRepository { get; }
        IServiceCatalogRepository ServiceCatalogRepository { get; }
        IServiceCatalogVersionRepository ServiceCatalogVersionRepository { get; }
        IServiceInstRepository ServiceInstRepository { get; }
        IServiceInstVersionRepository ServiceInstVersionRepository { get; }
        IShelfRepository ShelfRepository { get; }
        IStorageRepository StorageRepository { get; }
        IVehicleRepository VehicleRepository { get; }
        IDetailsServiceCatOrderRepairRepository DetailsServiceCategory { get; }
    }
}
