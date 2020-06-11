using Indico20.BusinessObjects.Repositories.Core;
using System;

namespace Indico20.BusinessObjects.Base.Core
{
    public interface IUnitOfWork : IDisposable
    {
        void Complete();
        ICompanyRepository CompanyRepository { get; }
        IUserStatusRepository UserStatusRepository { get; }
        IMenuItemRepository MenuItemRepository { get; }
        IUserRepository UserRepository { get; }
        IRoleRepository RoleRepository { get; }
        IOrderRepository OrderRepository { get; }
        IOrderDetailRepository OrderDetailRepository { get; }
        IAgeGroupRepository AgeGroupRepository { get; }
        IColourProfileRepository ColourProfileRepository { get; }
        IGenderRepository GenderRepository { get; }
        IPrinterRepository PrinterRepository { get; }
        IPrinterTypeRepository PrinterTypeRepository { get; }
        IProductionLineRepository ProductionLineRepository { get; }
    }
}
