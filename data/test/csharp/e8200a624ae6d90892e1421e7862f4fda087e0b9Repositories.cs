using Anketbaz.Database.Database;
using Anketbaz.Database.RepositoryTool;

namespace Anketbaz.Database.Repositories
{
    public class CompanyRepository : GenericDataRepository<company>, ICompanyRepository
    {
    }
    public class AnswerRepository : GenericDataRepository<answer>, IAnswerRepository
    {
    }
    public class GuestRepository : GenericDataRepository<guest>, IGuestRepository
    {
    }
    public class GuestAnswerRepository : GenericDataRepository<guestanswer>, IGuestAnswerRepository
    {
    } 
    public class PollRepository : GenericDataRepository<poll>, IPollRepository
    {
    }
    public class QuestionRepository : GenericDataRepository<question>, IQuestionRepository
    {
    }
    public class StaffRepository : GenericDataRepository<staff>, IStaffRepository
    {
    }
    public class UserRepository : GenericDataRepository<user>, IUserRepository
    {
    } 

}
