using Perfoma.DatabaseAccessLayer.Interfaces;
using Perfoma.DatabaseAccessLayer.Repositories;

namespace Perfoma.DatabaseAccessLayer
{
    public class DALContext
    {
        private IEmployeeRepository employeeRepository;

        public IEmployeeRepository EmployeeRepository
        {
            get { return this.employeeRepository ?? ( this.employeeRepository = new EmployeeRepository()); }
        }

        private ICustomerRepository customerRepository;


        public ICustomerRepository CustomerRepository
        {
            get { return this.customerRepository ?? (this.customerRepository = new CustomerRepository()); }
        }

        private IProjectRepository projectRepository;

        public IProjectRepository ProjectRepository
        {
            get { return this.projectRepository ?? (this.projectRepository = new ProjectRepository()); }
        }

        private IActivityRepository activityRepository;

        public IActivityRepository ActivityRepository
        {
            get { return this.activityRepository ?? (this.activityRepository = new ActivityRepository()); }
        }

        private ITaskRepository taskRepository;

        public ITaskRepository TaskRepository
        {
            get { return this.taskRepository ?? (this.taskRepository = new TaskRepository()); }
        }

        private IInvoiceRepository invoiceRepository;

        public IInvoiceRepository InvoiceRepository
        {
            get { return this.invoiceRepository ?? (this.invoiceRepository = new InvoiceRepository()); }
        }

    }
}
