using System;
using LayqaMVC.Repository.Entity;

namespace LayqaMVC.Repository.DDDContext
{
    public interface ILayqaMVCRepository : IDisposable
    {
        IGenericRepository<AdmProfile> AdmProfileRepository { get; }
        IGenericRepository<AdmUser> AdmUserRepository { get; }
        IGenericRepository<WebUser> WebUserRepository { get; }
        //IGenericRepository<Section> SectionRepository { get; }
        IGenericRepository<AdmMenu> AdmMenuRepository { get; }
        IGenericRepository<Post> PostRepository { get; }
        IGenericRepository<Comment> CommentRepository { get; }
        IGenericRepository<CmsSchema> SchemaRepository { get; }
        IGenericRepository<CmsArticle> ArticleRepository { get; }

        void Commit();
    }
}
