using DAL.Interfacies.Repository;
using System;

namespace DAL.Interface.Repository
{
    public interface IUnitOfWork : IDisposable
    {
        ITestRepository TestRepository { get; }
        IUserAnswerRepository UserAnswerRepository { get; }
        IResultRepository ResultRepository { get; }
        IQuestionRepository QuestionRrepository { get; }
        IQuestionAnswerRepository QuestionAnswerRepository { get; }
        IQuestionToTestRepository QuestionToTestRepository { get; }
        IRoleRepository RoleRepository { get; }
        IUserRepository UserRepository { get; }
        IStudyGroupRepository StudyGroupRepository { get; }
        IUsersToRoleRepository UsersToRoleRepository { get; }
        void Commit();
        //Rollback
    }
}