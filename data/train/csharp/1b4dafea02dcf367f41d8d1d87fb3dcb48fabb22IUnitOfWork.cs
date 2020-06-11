using System;
using api.Context.Repository;

namespace api.Context.Transaction
{
    public interface IUnitOfWork : IDisposable
    {
        void Save();
        void Rollback();

        UserRepository UserRepository { get; }
        ArenaRepository ArenaRepository { get; }
        PeladaRepository PeladaRepository { get; }
        PeladaTeamRepository PeladaTeamRepository { get; }
        PeladaUserRepository PeladaUserRepository { get; }
        PeladaEventRepository PeladaEventRepository { get; }
    }
}