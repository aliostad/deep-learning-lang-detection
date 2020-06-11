using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Interfacies.Concrete
{
    public interface IUnitOfWork : IDisposable
    {
        IClassRoomRepository ClassRoomRepository { get; }
        ICommentRepository CommentRepository { get; }
        IMailRepository MailRepository { get; }
        IParentRepository ParentRepository { get; }
        IPupilRepository PupilRepository { get; }
        IRequisitionRepository RequisitionRepository { get; }
        IRoleRepository RoleRepository { get; }
        ITeacherRepository TeacherRepository { get; }
        IUserRepository UserRepository { get; }
        void Saving();
    }
}
