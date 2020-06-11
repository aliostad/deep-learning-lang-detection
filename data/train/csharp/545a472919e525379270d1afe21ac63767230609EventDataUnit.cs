using EventManagementSystem.Data.Model;
using EventManagementSystem.Data.Repositories;
using EventManagementSystem.Data.Repositories.Interfaces;
using EventManagementSystem.Data.UnitOfWork.Base;
using EventManagementSystem.Data.UnitOfWork.Interfaces;

namespace EventManagementSystem.Data.UnitOfWork
{
    public class EventDataUnit : EntitiesUnitOfWork, IEventDataUnit
    {
        public EventDataUnit()
            : base(new EmsEntities())
        {
            RegisterRepository<Event, EventsRepository>();
            RegisterRepository<Corresponcence, CorresponcencesRepository>();
            RegisterRepository<EventUpdate, EventUpdatesRepository>();
            RegisterRepository<Room, RoomsRepository>();
            RegisterRepository<Golf, GolfsRepository>();
            RegisterRepository<EventRoom, EventRoomsRepository>();
            RegisterRepository<EventGolf, EventGolfsRepository>();
            RegisterRepository<EventCatering, EventCateringsRepository>();
            RegisterRepository<ContactTitle, ContactTitlesRepository>();
            RegisterRepository<Contact, ContactsRepository>();
            RegisterRepository<EventStatus, EventStatusesRepository>();
            RegisterRepository<EventType, EventTypesRepository>();
            RegisterRepository<EventContact, EventContactsRepository>();
            RegisterRepository<EventCharge, EventChargesRepository>();
            RegisterRepository<EventBookedProduct, EventBookedProductsRepository>();
            RegisterRepository<EventInvoice, EventInvoicesRepository>();
            RegisterRepository<EventNote, EventNotesRepository>();
            RegisterRepository<EventPayment, EventPaymentsRepository>();
            RegisterRepository<Report, ReportsRepository>();
            RegisterRepository<Product, ProductsRepository>();
            RegisterRepository<Invoice, InvoicesRepository>();
            RegisterRepository<MailTemplate, MailTemplatesRepository>();
            RegisterRepository<CorresponcenceType, CorresponcenceTypesRepository>();
            RegisterRepository<Document, DocumentsRepository>();
            RegisterRepository<GolfHole, GolfHolesRepository>();
            RegisterRepository<User, UsersRepository>();
            RegisterRepository<EventNoteType, EventNoteTypesRepository>();
            RegisterRepository<PaymentMethod, PaymentMethodsRepository>();
            RegisterRepository<CalendarNote, CalendarNotesRepository>();
            RegisterRepository<CCContactsCorrespondence, CCContactsCorrespondenceRepository>();
            RegisterRepository<CorrespondenceDocument, CorrespondenceDocumentsRepository>();
            RegisterRepository<EventReminder, EventRemindersRepository>();
            RegisterRepository<FollowUpStatus, FollowUpStatusesRepository>();
            RegisterRepository<EmailHeader, EmailHeadersRepository>();

        }

        public ICalendarNotesRepository CalendarNotesRepository
        {
            get { return (ICalendarNotesRepository)GetRepository<CalendarNote>(); }
        }

        public IPaymentMethodsRepository PaymentMethodsRepository
        {
            get { return (IPaymentMethodsRepository)GetRepository<PaymentMethod>(); }
        }

        public IEventNoteTypesRepository EventNoteTypesRepository
        {
            get { return (IEventNoteTypesRepository)GetRepository<EventNoteType>(); }
        }

        public IUsersRepository UsersRepository
        {
            get { return (IUsersRepository)GetRepository<User>(); }
        }

        public IGolfHolesRepository GolfHolesRepository
        {
            get { return (IGolfHolesRepository)GetRepository<GolfHole>(); }
        }

        public IDocumentsRepository DocumentsRepository
        {
            get { return (IDocumentsRepository)GetRepository<Document>(); }
        }

        public ICorresponcenceTypesRepository CorresponcenceTypesRepository
        {
            get { return (ICorresponcenceTypesRepository)GetRepository<CorresponcenceType>(); }
        }

        public IMailTemplatesRepository MailTemplatesRepository
        {
            get { return (IMailTemplatesRepository)GetRepository<MailTemplate>(); }
        }

        public IInvoicesRepository InvoicesRepository
        {
            get { return (IInvoicesRepository)GetRepository<Invoice>(); }
        }

        public IProductsRepository ProductsRepository
        {
            get { return (IProductsRepository)GetRepository<Product>(); }
        }

        public IReportsRepository ReportsRepository
        {
            get { return (IReportsRepository)GetRepository<Report>(); }
        }

        public IEventPaymentsRepository EventPaymentsRepository
        {
            get { return (IEventPaymentsRepository)GetRepository<EventPayment>(); }
        }

        public IEventNotesRepository EventNotesRepository
        {
            get { return (IEventNotesRepository)GetRepository<EventNote>(); }
        }

        public IEventInvoicesRepository EventInvoicesRepository
        {
            get { return (IEventInvoicesRepository)GetRepository<EventInvoice>(); }
        }

        public IEventBookedProductsRepository EventBookedProductsRepository
        {
            get { return (IEventBookedProductsRepository)GetRepository<EventBookedProduct>(); }
        }

        public IEventChargesRepository EventChargesRepository
        {
            get { return (IEventChargesRepository)GetRepository<EventCharge>(); }
        }

        public IEventContactsRepository EventContactsRepository
        {
            get { return (IEventContactsRepository)GetRepository<EventContact>(); }
        }

        public IEventTypesRepository EventTypesRepository
        {
            get { return (IEventTypesRepository)GetRepository<EventType>(); }
        }

        public IEventStatusesRepository EventStatusesRepository
        {
            get { return (IEventStatusesRepository)GetRepository<EventStatus>(); }
        }

        public IContactsRepository ContactsRepository
        {
            get { return (IContactsRepository)GetRepository<Contact>(); }
        }

        public IContactTitlesRepository ContactTitlesRepository
        {
            get { return (IContactTitlesRepository)GetRepository<ContactTitle>(); }
        }

        public IEventCateringsRepository EventCateringsRepository
        {
            get { return (IEventCateringsRepository)GetRepository<EventCatering>(); }
        }

        public IEventGolfsRepository EventGolfsRepository
        {
            get { return (IEventGolfsRepository)GetRepository<EventGolf>(); }
        }

        public IEventRoomsRepository EventRoomsRepository
        {
            get { return (IEventRoomsRepository)GetRepository<EventRoom>(); }
        }

        public IGolfsRepository GolfsRepository
        {
            get { return (IGolfsRepository)GetRepository<Golf>(); }
        }

        public IRoomsRepository RoomsRepository
        {
            get { return (IRoomsRepository)GetRepository<Room>(); }
        }

        public IEventUpdatesRepository EventUpdatesRepository
        {
            get { return (IEventUpdatesRepository)GetRepository<EventUpdate>(); }
        }

        public ICorresponcencesRepository CorresponcencesRepository
        {
            get { return (ICorresponcencesRepository)GetRepository<Corresponcence>(); }
        }

        public IEventsRepository EventsRepository
        {
            get { return (IEventsRepository)GetRepository<Event>(); }
        }

        public ICCContactsCorrespondenceRepository CCContactsCorrespondenceRepository
        {
            get { return (ICCContactsCorrespondenceRepository)GetRepository<CCContactsCorrespondence>(); }
        }

        public ICorrespondenceDocumentsRepository CorrespondenceDocumentsRepository
        {
            get { return (ICorrespondenceDocumentsRepository)GetRepository<CorrespondenceDocument>(); }
        }

        public IEventRemindersRepository EventRemindersRepository
        {
            get { return (IEventRemindersRepository)GetRepository<EventReminder>(); }
        }
        public IFollowUpStatusesRepository FollowUpStatusesRepository
        {
            get { return (IFollowUpStatusesRepository)GetRepository<FollowUpStatus>(); }
        }
        public IEmailHeadersRepository EmailHeadersRepository
        {
            get { return (IEmailHeadersRepository)GetRepository<EmailHeader>(); }
        }
    }
}
