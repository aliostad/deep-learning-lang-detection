using Falcon.Data.Repositories;
using System;

namespace Falcon.Data.Infrastructure
{
    public interface IUnitOfWork : IDisposable
    {
        void Commit();

        IAdminRepository AdminRepository { get; }
        IBankAccountRepository BankAccountRepository { get; }
        ICategoryRepository CategoryRepository { get; }
        ICircleRepository CircleRepository { get; }
        IComplaintRepository ComplaintRepository { get; }
        ICvRepository CvRepository { get; }
        IDocumentRepository DocumentRepository { get; }
        IEvaluationRepository EvaluationRepository { get; }
        IEventRepository EventRepository { get; }
        IFreelancerRepository FreelancerRepository { get; }
        IMemberRepository MemberRepository { get; }
        IMissionRepository MissionRepository { get; }
        IOwnerRepository OwnerRepository { get; }
        IPostRepository PostRepository { get; }
        IPrivateMessageRepository PrivateMessageRepository { get; }
    }
}
