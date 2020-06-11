using DataAccess.Domain;
using MyFrameWork.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories.Impl
{
    public class QuestionRepository : Repository<Question>, IQuestionRepository
    {
        public QuestionRepository(IMySqlRepositoryContext repositoryContext)
            : base(repositoryContext)
        {
        }
    }
    public class QuestionItemRepository : Repository<QuestionItem>, IQuestionItemRepository
    {
        public QuestionItemRepository(IMySqlRepositoryContext repositoryContext)
            : base(repositoryContext)
        {
        }
    }
    public class QuestionSelectRepository : Repository<QuestionSelect>, IQuestionSelectRepository
    {
        public QuestionSelectRepository(IMySqlRepositoryContext repositoryContext)
            : base(repositoryContext)
        {
        }
    }
    public class QuestionSelectUserRepository : Repository<QuestionSelectUser>, IQuestionSelectUserRepository
    {
        public QuestionSelectUserRepository(IMySqlRepositoryContext repositoryContext)
            : base(repositoryContext)
        {
        }
    }
    public class QuestionUserRepository : Repository<QuestionUser>, IQuestionUserRepository
    {
        public QuestionUserRepository(IMySqlRepositoryContext repositoryContext)
            : base(repositoryContext)
        {
        }
    }
}
