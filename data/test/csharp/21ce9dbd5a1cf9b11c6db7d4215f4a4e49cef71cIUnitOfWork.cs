using TradeSystem.Framework.Entities;
using TradeSystem.Framework.Identity;

namespace TradeSystem.Repositories
{
    public interface IUnitOfWork
    {

        AppIdentityDbContext DbEntities { get; }
        BankRepository BankRepository { get; }
        CustomerRepository CustomerRepository { get; }
        CustomerProductRepository CustomerProductRepository { get; }
        CompanyUserRepository CompanyUserRepository { get; }
        ProductRepository ProductRepository { get; }
        RoleRepository RoleRepository { get; }
        RoleSideMenuRepository<RoleSideMenu> RoleSideMenuRepository { get; }
        SideMenuRepository SideMenuRepository { get; }
        TicketRepository TicketRepository { get; }
        WithdrawRepository WithdrawRepository { get; }
        EmailRepository EmailRepository { get; }
        PenaltyRepository PenaltyRepository { get; }
        DocumentRepository DocumentRepository { get; }
        CountryRepository CountryRepository { get; }
        StateRepository StateRepository { get; }
        ActivityLogRepository ActivityLogRepository { get; }
        PromotionRepository PromotionRepository { get; }
        TicketStatusRepository TicketStatusRepository { get; }
        WalletRepository WalletRepository { get; }

        void Commit();
        void CommitTransaction();
    }
}
