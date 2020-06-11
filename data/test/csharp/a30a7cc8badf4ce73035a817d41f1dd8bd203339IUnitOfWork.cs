using System;

namespace DAL.Interfacies.Repository
{
    public interface IUnitOfWork : IDisposable
    {
        IUserRepository UserRepository { get; }
        IRoleRepository RoleRepository { get; }
        IUserRoleRepository UserRoleRepository { get; }
        IArticleRepository ArticleRepository { get; }
        ITagRepository TagRepository { get; }
        IArticleTagRepository ArticleTagRepository { get; }
        ICommentRepository CommentRepository { get; }
        IBlogRepository BlogRepository { get; }

        void Commit();
    
    }
}