using System;

namespace Team16.ComfortBank.Data.Interfaces.UnitOfWork
{
    public interface IUnitOfWork : IDisposable
    {
        IAccountRepository AccountRepository { get; }
        IAccountTypeRepository AccountTypeRepository { get; }
        IAttachmentRepository AttachmentRepository { get; }
        IAutomatedPaymentRepository AutomatedPaymentRepository { get; }
        ICreditAccountRepository CreditAccountRepository { get; }
        ICurrencyRepository CurrencyRepository { get; }
        IDepositAccountRepository DepositAccountRepository { get; }
        IDocumentRepository DocumentRepository { get; }
        IEmailLetterRepository EmailLetterRepository { get; }
        IPayableRepository PayableRepository { get; }
        IPaymentRepository PaymentRepository { get; }
        IRecipientRepository RecipientRepository { get; }
        IRoleRepository RoleRepository { get; }
        IUpisItemFieldRepository UpisItemFieldRepository { get; }
        IUpisItemRepository UpisItemRepository { get; }
        IUpisTemplateFieldRepository UpisTemplateFieldRepository { get; }
        IUpisTemplateRepository UpisTemplateRepository { get; }
        IUserRepository UserRepository { get; }
        void SaveChanges();
    }
}
