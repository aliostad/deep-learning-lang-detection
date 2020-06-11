using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TG.Data.Providers
{
    public interface IDataProvider : IDisposable
    {
        IBadgeRepository CreateBadgeRepository();
        ICommentRepository CreateCommentRepository();
        IEvaluationRepository CreateEvaluationRepository();
        IGoalsRepository CreateGoalsRepository();
        IPersonRepository CreatePersonRepository();
        IProblemRepository CreateProblemRepository();
        ISolutionRepository CreateSolutionRepository();
        IPersonClassRepository CreatePersonClassRepository();
        IClassRepository CreateClassRepository();
        IPersonBadgeRepository CreatePersonBadgeRepository();
        IPersonProblemRepository CreatePersonProblemRepository();
        IProblemBadgeRepository CreateProblemBadgeRepository();
        IReviewRepository CreateReviewRepository();
        IReflectRepository CreateReflectRepository();
        IResultRepository CreateResultRepository();
    }
}
