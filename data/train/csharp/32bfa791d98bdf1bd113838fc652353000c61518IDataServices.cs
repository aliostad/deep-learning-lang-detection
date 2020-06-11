using Cresce.Business.IO.Interfaces.Repositories;

namespace Cresce.Business.IO.Interfaces
{
    public interface IDataServices : IInitialize
    {
        IAppointmentRepository AppointmentRepository { get; set; }
        IPatientRepository PatientRepository { get; set; }
        IServiceRepository ServiceRepository { get; set; }
        IContractRepository ContractRepository { get; set; }
        IServicePackRepository ServicePackRepository { get; set; }
        IUserRepository UserRepository { get; set; }
        IAppointmentResourcesRepository AppointmentResourcesRepository { get; }
        IInvoiceRepository InvoiceRepository { get; set; }
        IDiscountRepository DiscountRepository { get; set; }
        IPaymentRepository PaymentRepository { get; set; }
    }
}