using System;
using System.Threading.Tasks;

namespace APRST.DAL.Interfaces
{
    public interface IUnitOfWork:IDisposable
    {
        ITestRepository TestRepository { get; }
        ITestCategoryRepository TestCategoryRepository { get; }
        ITestQuestionRepository TestQuestionRepository { get; }
        ITestAnswerRepository TestAnswerRepository { get; }
        ITestResultRepository TestResultRepository { get; }
        IUserProfileRepository UserProfileRepository { get; }
        IRoleRepository RoleRepository { get; }
        IQuestionnaireCategoryRepository QuestionnaireCategoryRepository { get; }
        IQuestionnaireQuestionRepository QuestionnaireQuestionRepository { get; }
        IQuestionnaireRepository QuestionnaireRepository { get; }
        IQuestionnaireTypeRepository QuestionnaireTypeRepository { get; }
        IQuestionnaireResultRepository QuestionnaireResultRepository { get; }
        ILogRepository LogRepository { get; }
        void Save();
        Task SaveAsync();
    }
}
