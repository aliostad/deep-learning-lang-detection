using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Differences.Interaction.Repositories;
using GraphQL.Types;

namespace Differences.Api
{
    public abstract class GraphQLTypeBase<T> : ObjectGraphType<T>
    {
        protected IArticleRepository _articleRepository;
        protected IQuestionRepository _questionRepository;
        protected IReplyRepository _replyRepository;

        public GraphQLTypeBase() { }

        public GraphQLTypeBase(
            IArticleRepository articleRepository, 
            IQuestionRepository questionRepository, 
            IReplyRepository replyRepository)
        {
            _articleRepository = articleRepository;
            _questionRepository = questionRepository;
            _replyRepository = replyRepository;
        }
    }
}
