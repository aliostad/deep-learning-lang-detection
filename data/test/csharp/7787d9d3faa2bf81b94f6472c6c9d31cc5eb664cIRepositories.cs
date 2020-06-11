
using Anketbaz.Database.Database;
using Anketbaz.Database.RepositoryTool;

namespace Anketbaz.Database.Repositories
{
    public interface ICompanyRepository : IGenericDataRepository<company>
    {
    }
    public interface IAnswerRepository : IGenericDataRepository<answer>
    {
    }
    public interface IGuestRepository : IGenericDataRepository<guest>
    {
    }
    public interface IGuestAnswerRepository : IGenericDataRepository<guestanswer>
    {
    } 
    public interface IPollRepository : IGenericDataRepository<poll>
    {
    }
    public interface IQuestionRepository : IGenericDataRepository<question>
    {
    }
    public interface IStaffRepository : IGenericDataRepository<staff>
    {
    }
    public interface IUserRepository : IGenericDataRepository<user>
    {
    } 
  
}
