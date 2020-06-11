using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Freelancer.Data.Infrastructure
{
    public interface IUnitOfWork : IDisposable
    {
        void Commit();

        IUserRepository UserRepository { get; }
        IJobRepository JobRepository { get; }
        IBankRepository BankRepository { get; }
        IClaimRepository ClaimRepository { get; }
        ICategoryRepository CategoryRepository { get; }
        ISouscategoryRepository SouscategoryRepository { get; }
        IPaymentRepository PaymentRepository { get; }
        IFriendslistRepository FriendslistRepository { get; }
    }
}
