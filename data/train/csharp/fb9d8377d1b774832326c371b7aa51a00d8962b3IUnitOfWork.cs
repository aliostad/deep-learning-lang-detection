using System;
using IAmOpen.Site.Model.Models;

namespace IAmOpen.Site.Model.Abstractions
{
    public interface IUnitOfWork: IDisposable
    {
        IGenericRepository<Institution> InstitutionRepository { get; }

        IGenericRepository<InstitutionType> InstitutionTypeRepository { get; }

        IGenericRepository<User> UserRepository{ get; }

        IGenericRepository<Chain> ChainRepository{ get; }

        IGenericRepository<ExternalAccount> ExternalAccountRepository{ get; }

        IGenericRepository<WorkTime> WorkTimeRepository{ get; }

        IGenericRepository<Vote> VoteRepository{ get; }

        IGenericRepository<Review> ReviewRepository{ get; }

        IGenericRepository<UserExternalAccountToken> UserExtAccountRepository{ get; }

        IGenericRepository<Status> StatusRepository{ get; }

        IGenericRepository<Role> RoleRepository{ get; }

        IGenericRepository<State> StateRepository{ get; }

        void Save();
    }
}
