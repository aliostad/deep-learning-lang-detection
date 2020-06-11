using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using iRocks.DataLayer;

namespace iRocks.WebAPI.Controllers
{
    public class BaseApiController : ApiController
    {
        private IPostRepository    _PostRepository;
        private ICategoryRepository _CategoryRepository;
        private IVoteRepository _VoteRepository;
        private IUserRepository _UserRepository;

        public BaseApiController(IUserRepository userRepository, IPostRepository postRepository, IVoteRepository voteRepository, ICategoryRepository categoryRepository)
        {
            _UserRepository = userRepository;
            _PostRepository = postRepository;
            _VoteRepository = voteRepository;
            _CategoryRepository = categoryRepository;

        }

        protected IPostRepository ThePostRepository
        {
            get
            {
                return _PostRepository;
            }
        }
        protected ICategoryRepository TheCategoryRepository
        {
            get
            {
                return _CategoryRepository;
            }
        }
        protected IVoteRepository TheVoteRepository
        {
            get
            {
                return _VoteRepository;
            }
        }
        protected IUserRepository TheUserRepository
        {
            get
            {
                return _UserRepository;
            }

        }
        
    }
}
