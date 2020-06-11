using DAL.Interface.Repository;
using ORM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Concrete
{
    public class UnitOfWork : IUnitOfWork
    {
        private EntityModel Context;

        private UserRepository userRepository;
        private RoleRepository roleRepository;
        private UserRoleRepository userRoleRepository;
        private TestRepository testRepository;
        private QuestionRepository questionRepository;
        private AnswerRepository answerRepository;
        private ResultRepository resultRepository;

        public UnitOfWork(EntityModel context)
        {
            Context = context;
        }

        public IRoleRepository RoleRepository
        {
            get
            {
                if (roleRepository == null)
                    roleRepository = new RoleRepository(Context);

                return roleRepository;
            }
        }

        public IUserRepository UserRepository
        {
            get
            {
                if (userRepository == null)
                    userRepository = new UserRepository(Context);

                return userRepository;
            }
        }

        public IUserRoleRepository UserRoleRepository
        {
            get
            {
                if (userRoleRepository == null)
                    userRoleRepository = new UserRoleRepository(Context);

                return userRoleRepository;
            }
        }

        public ITestRepository TestRepository
        {
            get
            {
                if (testRepository == null)
                    testRepository = new TestRepository(Context);

                return testRepository;
            }
        }

        public IQuestionRepository QuestionRepository
        {
            get
            {
                if (questionRepository == null)
                    questionRepository = new QuestionRepository(Context);

                return questionRepository;
            }
        }

        public IAnswerRepository AnswerRepository
        {
            get
            {
                if (answerRepository == null)
                    answerRepository = new AnswerRepository(Context);

                return answerRepository;
            }
        }

        public IResultRepository ResultRepository
        {
            get
            {
                if (resultRepository == null)
                    resultRepository = new ResultRepository(Context);

                return resultRepository;
            }
        }

        public void Commit()
        {
            if (Context != null)
            {
                Context.SaveChanges();
            }
        }

        public void Dispose()
        {
            if (Context != null)
            {
                Context.Dispose();
            }
        }
    }
}
