using EventManagementSystem.Data.Repositories.Interfaces;
using EventManagementSystem.Data.UnitOfWork.Base;

namespace EventManagementSystem.Data.UnitOfWork.Interfaces
{
    public interface IReportsDataUnit : IDataUnitOfWork
    {
        IActivitiesRepository ActivitiesRepository { get; }
        IActivityTypesRepository ActivityTypesRepository { get; }
        IEventTypesRepository EventTypesRepository { get; }
        IEnquiriesRepository EnquiriesRepository { get; }
        IEventsRepository EventsRepository { get; }
        IEventPaymentsRepository EventPaymentsRepository { get; }
        IProductVatRatesRepository ProductVatRatesRepository { get; }
        IProductGroupsRepository ProductGroupsRepository { get; }
        IProductDepartmentsRepository ProductDepartmentsRepository { get; }
        IEventBookedProductsRepository EventBookedProductsRepository { get; }
        ITillsRepository TillsRepository { get; }
        IFinaliseKeysRepository FinaliseKeysRepository { get; }
        ITillProductsRepository TillProductsRepository { get; }
        IClerksRepository ClerksRepository { get; }
        ITillTransactionsRepository TillTransactionsRepository { get; }
        ITillTransactionProductsRepository TillTransactionProductsRepository { get; }
        ITillTransactionFinaliseKeysRepository TillTransactionFinaliseKeysRepository { get; }
        IProductsRepository ProductsRepository { get; }
        IMembersRepository MembersRepository { get; }
    }
}
