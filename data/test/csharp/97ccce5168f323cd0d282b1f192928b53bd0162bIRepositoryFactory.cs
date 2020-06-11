using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public interface IRepositoryFactory
    {
        ICompanyRepository GetCompanyRepository();
        IDealRepository GetDealRepository();
        IEntityRepository GetObjectRepository();
        IPersonRepository GetPersonRepository(string tableName);
        IPersonRepository GetOwnerRepository();
        IPersonRepository GetClientRepository();
        IShowRepository GetShowRepository();
        IStaffRepository GetStaffRepository();
        IWishRepository GetWishRepository();
        ISpecialRepository GetSpecialRepository();
    }
}
