using FileHosting.Database.Models;
using System;

namespace FileHosting.Database
{
    public interface IUnitOfWork : IDisposable
    {
        #region Repository Interfaces (add one per entity)

        IGenericRepository<Comment> CommentRepository { get; }
        IGenericRepository<Download> DownloadRepository { get; }
        IGenericRepository<File> FileRepository { get; }
        IGenericRepository<News> NewsRepository { get; }
        IGenericRepository<Role> RoleRepository { get; }
        IGenericRepository<Section> SectionRepository { get; }
        IGenericRepository<Tag> TagRepository { get; }
        IGenericRepository<User> UserRepository { get; }

        #endregion

        void Commit();
    }
}