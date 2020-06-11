using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Wallnut.BusinessLogic.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {

        #region Repositories
         IAddressRepository AddressRepository { get; }
         IAddressTypesRepository AddressTypesRepository { get;  }
         ICountryRegionRepository CountryRegionRepository { get;  }
         ICurrencyRateRepository CurrencyRateRepository { get;  }
         ICustomerRepository CustomerRepository { get;  }
         IEmailAddressRepository EmailAddressRepository { get;  }
         IEmployeeDepartmentHistoryRepository EmployeeDepartmentHistoryRepository { get;  }
         IPersonPhoneRepository PersonPhoneRepository { get;  }
         ILocationRepository LocationRepository { get;  }
         IPhoneNumberTypeRepository PhoneNumberTypeRepository { get;  }
         IProductListPriceHistoryRepository ProductListPriceHistoryRepository { get;  }
         IProductVendorRepository ProductVendorRepository { get;  }
         IPurchaseOrderDetailRepository PurchaseOrderDetailRepository { get;  }
         IPurchaseOrderHeaderRepository PurchaseOrderHeaderRepository { get;  }
         ISalesOrderDetailRepository SalesOrderDetailRepository { get;  }
         IStateProvinceRepository StateProvinceRepository { get;  }
         IVendorRepository VendorRepository { get;  }
         IEmployeeRepository EmployeeRepository { get;  }
         IDepartmentRepository DepartmentRepository { get;  }
         IProductsRepository ProductsRepository { get;  }
         IUnitMeasureRepository UnitMeasureRepository { get;  }
         IPasswordRepository PasswordRepository { get;  }
         IShiftRepository ShiftRepository { get;  }
         ICurrencyRepository CurrencyRepository { get;  }
         IContactTypeRepository ContactTypeRepository { get; }
        #endregion
        int Complete();
    }
}
