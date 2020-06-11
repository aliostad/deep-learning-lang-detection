using EventManagementSystem.Data.Repositories.Interfaces;
using EventManagementSystem.Data.UnitOfWork.Base;

namespace EventManagementSystem.Data.UnitOfWork.Interfaces
{
    public interface IMembershipDataUnit : IDataUnitOfWork
    {
        IMembersRepository MembersRepository { get; }
        IContactsRepository ContactsRepository { get; }
        IContactTitlesRepository ContactTitlesRepository { get; }
        ICCContactsCorrespondenceRepository CCContactsCorrespondenceRepository { get; }
        ICorresponcenceTypesRepository CorresponcenceTypesRepository { get; }
        ICorresponcencesRepository CorresponcencesRepository { get; }
        IMembershipCategoriesRepository MembershipCategoriesRepository { get; }
        IMemberNotesRepository MemberNotesRepository { get; }
        IMembershipUpdatesRepository MembershipUpdatesRepository { get; }
        IMailTemplatesRepository MailTemplatesRepository { get; }
        IEmailHeadersRepository EmailHeadersRepository { get; }
        ISystemSettingsRepository SystemSettingsRepository { get; }
    }
}
