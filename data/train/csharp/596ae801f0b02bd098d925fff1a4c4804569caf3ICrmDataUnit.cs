using EventManagementSystem.Data.Repositories.Interfaces;
using EventManagementSystem.Data.UnitOfWork.Base;

namespace EventManagementSystem.Data.UnitOfWork.Interfaces
{
    public interface ICrmDataUnit : IDataUnitOfWork
    {
        ICampaignTypesRepository CampaignTypesRepository { get; }
        ICampaignsRepository CampaignsRepository { get; }
        IFollowUpStatusesRepository FollowUpStatusesRepository { get; }
        IEnquiriesRepository EnquiriesRepository { get; }
        IFollowUpsRepository FollowUpsRepository { get; }
        IActivitiesRepository ActivitiesRepository { get; }
        IEnquiryUpdatesRepository EnquiryUpdatesRepository { get; }
        IEventStatusesRepository EventStatusesRepository { get; }
        IEventTypesRepository EventTypesRepository { get; }
        IEventNoteTypesRepository EventNoteTypesRepository { get; }
        IEventNotesRepository EventNotesRepository { get; }
        ICorresponcencesRepository CorresponcencesRepository { get; }
        ICorrespondenceDocumentsRepository CorrespondenceDocumentsRepository { get; }
        ICCContactsCorrespondenceRepository CCContactsCorrespondenceRepository { get; }
        IUsersRepository UsersRepository { get; }
        IEnquiryStatusesRepository EnquiryStatusesRepository { get; }
        IEnquiryReceiveMethodsRepository EnquiryReceiveMethodsRepository { get; }
        IEnquiryNotesRepository EnquiryNotesRepository { get; }
        IActivityTypesRepository ActivityTypesRepository { get; }
        ICorresponcenceTypesRepository CorresponcenceTypesRepository { get; }
        IContactsRepository ContactsRepository { get; }
        IEventsRepository EventsRepository { get; }
        IEventUpdatesRepository EventUpdatesRepository { get; }
        IMailTemplatesRepository MailTemplatesRepository { get; }
        IDocumentsRepository DocumentsRepository { get; }
        IEventContactsRepository EventContactsRepository { get; }
        IEmailHeadersRepository EmailHeadersRepository { get; }
    }
}
