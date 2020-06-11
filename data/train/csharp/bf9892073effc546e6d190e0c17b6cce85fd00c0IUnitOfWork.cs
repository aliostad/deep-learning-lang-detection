using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccess.Interface.EntityFramework;
namespace DataAccess.Interface.Repository
{
    public interface IUnitOfWork : IDisposable
    {
        ITaskRepository TaskRepository { get; }
        IUserRepository UserRepository { get; }
        ITagRepository TagRepository { get; }
        IAnswerRepository AnswerRepository { get; }
        IPhotoRepository PhotoRepository { get; }
        IUserAnswerRepository UserAnswerRepository { get; }
        ICommentRepository CommentRepository { get; }
        IRepository<Authorization> AuthorizationRepository { get; }
        IAchievementRepository AchievementRepository { get; }
        void Save();

    }
}
