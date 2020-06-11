using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Test.Data.Repositories;

namespace Test.Data
{
    public interface IDataProvider
    {
        IAuthenticationRepository AuthenticationRepository { get; }
        IUserRepository UserRepository { get; }
        IUserRolesRepository UserRolesRepository { get; }
        IUserLoginsRepository UserLoginsRepository { get; }
        IUserClaimsRepository UserClaimsRepository { get; }
        IRoleRepository RoleRepository { get; }
        IMusicRepository MusicRepository { get; }
        IAuthenticationRepository GetAuthenticationRepository(string connectionString);

    }
}
