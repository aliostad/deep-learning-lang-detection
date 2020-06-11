using System;
using System.Collections.Generic;
using System.Text;
using Domain.Contracts.Repositories;

namespace Domain.Contracts
{
    public interface IUnitOfWork
    {
        void Commit();
        void Rollback();

        IUserRepository UserRepository { get; }
        IRoleRepository RoleRepository { get; }
        ISchemaRepository SchemaRepository { get; }
        IStitchRepository StitchRepository { get; }
        ICategoryRepository CategoryRepository { get; }
        ISchemaFileRepository SchemaFileRepository { get; }
        ISchemaImageRepository SchemaImageRepository { get; }
    }
}
