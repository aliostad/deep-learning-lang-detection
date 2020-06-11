using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FacturatieSysteem.Models
{
    public class UnitOfWork : IDisposable
    {
        public FacturatieSysteemContext Context { get; set; }

        private AddressRepository addressRepository;
        private CustomerRepository customerRepository;
        private DepartmentRepository departmentRepository;
        private HourRegistrationRepository hourRegistrationRepository;
        private HourRegistrationDetailRepository hourRegistrationDetailRepository;
        private InvoiceRepository invoiceRepository;
        private InvoiceDetailRepository invoiceDetailRepository;
        private RateRepository rateRepository;
        private RoleRepository roleRepository;
        private UserRepository userRepository;

        public UserRepository UserRepository
        {
            get
            {
                if (userRepository == null)
                {
                    userRepository = new UserRepository(Context);
                }
                return userRepository;
            }
            set { userRepository = value; }
        }
        

        public RoleRepository RoleRepository
        {
            get
            {
                if (roleRepository == null)
                {
                    roleRepository = new RoleRepository(Context);
                }
                return roleRepository;
            }
            set { roleRepository = value; }
        }
        

        public RateRepository RateRepository
        {
            get
            {
                if (rateRepository == null)
                {
                    rateRepository = new RateRepository(Context);
                }
                return rateRepository;
            }
            set { rateRepository = value; }
        }
        

        public InvoiceDetailRepository InvoiceDetailRepository
        {
            get
            {
                if (invoiceDetailRepository == null)
                {
                    invoiceDetailRepository = new InvoiceDetailRepository(Context);                
                }
                return invoiceDetailRepository;
            }
            set { invoiceDetailRepository = value; }
        }
        

        public InvoiceRepository InvoiceRepository
        {
            get 
            {
                if (invoiceRepository == null)
                {
                    invoiceRepository = new InvoiceRepository(Context);
                }
                return invoiceRepository;
            }
            set { invoiceRepository = value; }
        }
        

        public HourRegistrationDetailRepository HourRegistrationDetailRepository
        {
            get
            {
                if (hourRegistrationDetailRepository == null)
                {
                    hourRegistrationDetailRepository = new HourRegistrationDetailRepository(Context);
                }
                return hourRegistrationDetailRepository;
            }
            set { hourRegistrationDetailRepository = value; }
        }
        

        public HourRegistrationRepository HourRegistrationRepository
        {
            get
            {
                if (hourRegistrationRepository == null)
                {
                    hourRegistrationRepository = new HourRegistrationRepository(Context);
                }
                return hourRegistrationRepository;
            }
            set { hourRegistrationRepository = value; }
        }
        

        public DepartmentRepository DepartmentRepository
        {
            get
            {
                if(departmentRepository == null)
                {
                    departmentRepository = new DepartmentRepository(Context);
                }
                return departmentRepository;
            }
            
            set { departmentRepository = value; }
        }
        

        public CustomerRepository CustomerRepository
        {
            get
            {
                if (customerRepository == null)
                {
                    customerRepository = new CustomerRepository(Context);
                }
                return customerRepository;
            }
            set { customerRepository = value; }
        }
        

        public AddressRepository AddressRepository
        {
            get
            {
                if (addressRepository == null)
                {
                    addressRepository = new AddressRepository(Context);
                }
                return addressRepository;
            }
            set { addressRepository = value; }
        }
         

        public void Dispose()
        {
            Context.Dispose();
        }

        public UnitOfWork()
        {
            Context = new FacturatieSysteemContext();
        }
    }
}