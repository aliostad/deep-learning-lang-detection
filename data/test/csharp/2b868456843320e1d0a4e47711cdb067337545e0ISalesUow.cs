using Northwind.Core.EntityLayer;

namespace Northwind.Core.DataLayer.Contracts
{
    public interface ISalesUow : IUow
    {
        IChangeLogRepository ChangeLogRepository { get; }

        ISupplierRepository SupplierRepository { get; }

        ICategoryRepository CategoryRepository { get; }

        IProductRepository ProductRepository { get; }

        IShipperRepository ShipperRepository { get; }

        ICustomerRepository CustomerRepository { get; }

        IEmployeeRepository EmployeeRepository { get; }

        IOrderRepository OrderRepository { get; }

        IOrderDetailRepository OrderDetailRepository { get; }

        IRegionRepository RegionRepository { get; }
    }
}
