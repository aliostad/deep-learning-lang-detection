using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TPP_MainProject.Models.entities;

namespace TPP_MainProject.Models.repository
{
    public class UnitOfWork : IDisposable
    {
        private ApplicationDbContext context = new ApplicationDbContext();
        private GenericRepository<Order> orderRepository;
        private GenericRepository<ApplicationUser> applicationRepository;
        private GenericRepository<Accountant> accountantRepository;
        private GenericRepository<WorkItem> workItemRepository;
        private GenericRepository<Resourse> resourceRepository;
        private GenericRepository<ProductItem> productItemRepository;
        private GenericRepository<OrderDetail> orderDetailsRepository;
        private GenericRepository<Project> projectRepository;
        private GenericRepository<Cart> cartRepository;
        private GenericRepository<Manager> managerRepository;
        private GenericRepository<Catagorie> catagorieRepository;
        private GenericRepository<Customer> customerRepository;
        public GenericRepository<Customer> CustomerRepository
        {
            get
            {

                if (this.customerRepository == null)
                {
                    this.customerRepository = new GenericRepository<Customer>(context);
                }
                return customerRepository;
            }
        }

        public GenericRepository<Catagorie> CatagorieRepositpry
        {
            get
            {

                if (this.catagorieRepository == null)
                {
                    this.catagorieRepository = new GenericRepository<Catagorie>(context);
                }
                return catagorieRepository;
            }
        }
        public GenericRepository<OrderDetail> OrderDetailRepository
        {
            get
            {

                if (this.orderDetailsRepository == null)
                {
                    this.orderDetailsRepository = new GenericRepository<OrderDetail>(context);
                }
                return orderDetailsRepository;
            }
        }
        public GenericRepository<Cart> CartRepository
        {
            get
            {

                if (this.cartRepository == null)
                {
                    this.cartRepository = new GenericRepository<Cart>(context);
                }
                return cartRepository;
            }
        }

        public GenericRepository<ProductItem> ProductItemRepository
        {
            get
            {

                if (this.productItemRepository == null)
                {
                    this.productItemRepository = new GenericRepository<ProductItem>(context);
                }
                return productItemRepository;
            }
        }

        public GenericRepository<Project> ProjectRepository
        {
            get
            {

                if (this.projectRepository == null)
                {
                    this.projectRepository = new GenericRepository<Project>(context);
                }
                return projectRepository;
            }
        }

        public GenericRepository<Manager> ManagerRepository
        {
            get
            {

                if (this.managerRepository == null)
                {
                    this.managerRepository = new GenericRepository<Manager>(context);
                }
                return managerRepository;
            }
        }
        public GenericRepository<Resourse> ResourceRepository
        {
            get
            {

                if (this.resourceRepository == null)
                {
                    this.resourceRepository = new GenericRepository<Resourse>(context);
                }
                return resourceRepository;
            }
        }

        public GenericRepository<Order> OrderRepository
        {
            get
            {

                if (this.orderRepository == null)
                {
                    this.orderRepository = new GenericRepository<Order>(context);
                }
                return orderRepository;
            }
        }

        public GenericRepository<WorkItem> WorkItemRepository
        {
            get
            {

                if (this.workItemRepository == null)
                {
                    this.workItemRepository = new GenericRepository<WorkItem>(context);
                }
                return workItemRepository;
            }
        }


        public GenericRepository<Accountant> AccountantRepository
        {
            get
            {

                if (this.accountantRepository == null)
                {
                    this.accountantRepository = new GenericRepository<Accountant>(context);
                }
                return accountantRepository;
            }
        }
        public GenericRepository<ApplicationUser> UserRepository
        {
            get
            {

                if (this.applicationRepository == null)
                {
                    this.applicationRepository = new GenericRepository<ApplicationUser>(context);
                }
                return applicationRepository;
            }
        }
        public void Save()
        {
            context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}