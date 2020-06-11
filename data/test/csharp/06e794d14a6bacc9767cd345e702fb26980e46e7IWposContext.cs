using System;
using whostpos.Entitys.Entites;

namespace whostpos.Domain.Interface
{
    public interface IWposContext : IDisposable
    {
        ICompanyInfo CompanyInformation { get; }
        IProductRepository ProductRepository { get; }
        IBankRepository BankRepository { get; }
        ISupplierRepository SupplierRepository { get; }
        ICustomerRepository CustomerRepository { get; }
        IOpeningClosingBlanceRepository OpeningClosingBlanceRepository { get; }
        IStockRepository StockRepository { get; }
        ITransactionRepository TransactionRepository { get; }
        IBaseRepository<Expenses> ExpensesRepository { get; }
        IUserAccountRepository UserAccountRepository { get; }
        void Save();
    }
}
