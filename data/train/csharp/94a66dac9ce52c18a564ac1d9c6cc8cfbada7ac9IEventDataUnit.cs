using EventManagementSystem.Data.Repositories.Interfaces;
using EventManagementSystem.Data.UnitOfWork.Base;

namespace EventManagementSystem.Data.UnitOfWork.Interfaces
{
    public interface IEventDataUnit : IDataUnitOfWork
    {
        IEventsRepository EventsRepository { get; }
        ICorresponcencesRepository CorresponcencesRepository { get; }
        IEventUpdatesRepository EventUpdatesRepository { get; }
        IRoomsRepository RoomsRepository { get; }
        IGolfsRepository GolfsRepository { get; }
        IEventRoomsRepository EventRoomsRepository { get; }
        IEventGolfsRepository EventGolfsRepository { get; }
        IEventCateringsRepository EventCateringsRepository { get; }
        IContactTitlesRepository ContactTitlesRepository { get; }
        IContactsRepository ContactsRepository { get; }
        IEventStatusesRepository EventStatusesRepository { get; }
        IEventTypesRepository EventTypesRepository { get; }
        IEventContactsRepository EventContactsRepository { get; }
        IEventChargesRepository EventChargesRepository { get; }
        IEventBookedProductsRepository EventBookedProductsRepository { get; }
        IEventInvoicesRepository EventInvoicesRepository { get; }
        IEventNotesRepository EventNotesRepository { get; }
        IEventPaymentsRepository EventPaymentsRepository { get; }
        IReportsRepository ReportsRepository { get; }
        IProductsRepository ProductsRepository { get; }
        IInvoicesRepository InvoicesRepository { get; }
        IMailTemplatesRepository MailTemplatesRepository { get; }
        ICorresponcenceTypesRepository CorresponcenceTypesRepository { get; }
        ICorrespondenceDocumentsRepository CorrespondenceDocumentsRepository { get; }
        ICCContactsCorrespondenceRepository CCContactsCorrespondenceRepository { get; }
        IDocumentsRepository DocumentsRepository { get; }
        IGolfHolesRepository GolfHolesRepository { get; }
        IUsersRepository UsersRepository { get; }
        IEventNoteTypesRepository EventNoteTypesRepository { get; }
        IPaymentMethodsRepository PaymentMethodsRepository { get; }
        ICalendarNotesRepository CalendarNotesRepository { get; }

        IEventRemindersRepository EventRemindersRepository { get; }
        IFollowUpStatusesRepository FollowUpStatusesRepository { get; }
        IEmailHeadersRepository EmailHeadersRepository { get; }
    }
}
