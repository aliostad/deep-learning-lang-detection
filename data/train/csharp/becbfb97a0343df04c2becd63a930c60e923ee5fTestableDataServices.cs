using Cresce.Business.IO.Interfaces;
using Cresce.Business.IO.Interfaces.Repositories;
using Moq;

namespace Cresce.Business.Tests
{
    public class TestableDataServices : IDataServices
    {
        public Mock<IPatientRepository> PatientRepositoryMock;
        public Mock<IServiceRepository> ServiceRepositoryMock;
        public Mock<IAppointmentRepository> AppointmentRepositoryMock;
        public Mock<IContractRepository> ContractRepositoryMock;
        public Mock<IUserRepository> UserRepositoryMock;
        public Mock<IInvoiceRepository> InvoiceRepositoryMock;
        public Mock<IDiscountRepository> DiscountRepositoryMock;
        public Mock<IPaymentRepository> PaymentRepositoryMock;

        public TestableDataServices()
        {
            CreateMocks();
        }

        private void SetMockInstances()
        {
            PatientRepository = PatientRepositoryMock.Object;
            ServiceRepository = ServiceRepositoryMock.Object;
            AppointmentRepository = AppointmentRepositoryMock.Object;
            ContractRepository = ContractRepositoryMock.Object;
            UserRepository = UserRepositoryMock.Object;
            InvoiceRepository = InvoiceRepositoryMock.Object;
            DiscountRepository = DiscountRepositoryMock.Object;
            PaymentRepository = PaymentRepositoryMock.Object;
        }

        private void CreateMocks()
        {
            PatientRepositoryMock = new Mock<IPatientRepository>();
            ServiceRepositoryMock = new Mock<IServiceRepository>();
            AppointmentRepositoryMock = new Mock<IAppointmentRepository>();
            ContractRepositoryMock = new Mock<IContractRepository>();
            UserRepositoryMock = new Mock<IUserRepository>();
            InvoiceRepositoryMock = new Mock<IInvoiceRepository>();
            DiscountRepositoryMock = new Mock<IDiscountRepository>();
            PaymentRepositoryMock = new Mock<IPaymentRepository>();

            SetMockInstances();
        }

        public void Init() { }

        public IAppointmentRepository AppointmentRepository { get; set; }
        public IPatientRepository PatientRepository { get; set; }
        public IServiceRepository ServiceRepository { get; set; }
        public IContractRepository ContractRepository { get; set; }
        public IServicePackRepository ServicePackRepository { get; set; }
        public IUserRepository UserRepository { get; set; }
        public IAppointmentResourcesRepository AppointmentResourcesRepository { get; set; }
        public IInvoiceRepository InvoiceRepository { get; set; }
        public IDiscountRepository DiscountRepository { get; set; }
        public IPaymentRepository PaymentRepository { get; set; }
    }
}