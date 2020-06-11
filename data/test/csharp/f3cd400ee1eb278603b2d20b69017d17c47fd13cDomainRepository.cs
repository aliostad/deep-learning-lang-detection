using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVCSampleGrid.Data.GenericRepository;

namespace MVCSampleGrid.Data.DomainRepository
{
    public class CustomerRepository : GenericRepository<Customer>, ICustomerRepository
    { }
    public class ProductRepository : GenericRepository<Product>, IProductRepository
    { }
    public class OrderRepository : GenericRepository<Order>, IOrderRepository
    { }
    public class OrderItemRepository : GenericRepository<OrderItem>, IOrderItemRepository
    { }
    public class SupplierRepository : GenericRepository<Supplier>, ISupplierRepository
    { }
    public class Tech_CompanyRepository : GenericRepository<Tech_Company>, ITech_CompanyRepository
    { }
    public class EmployeeRepository : GenericRepository<Employee>, IEmployeeRepository
    { }
}
    