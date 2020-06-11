using ESurvey.DAL.Abstract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ESurvey.DAL.Concrete;
using ESurvey.Entity;

namespace ESurvey.DAL.Concrate
{
    public class RepositoryHolder : IRepositoryHolder
    {
        protected ESurveyEntities _context;

        protected IAnsweredQuestionsOptionsRepository _answeredQuestionsOptionsRepository;
        protected IAnsweredQuestionsRepository _answeredQuestionsRepository;
        protected IAnswerRepository _answerRepository;
        protected IQuestionRepository _questionRepository;
        protected ISurveyRepository _surveyRepository;
        protected ISurveySessionRepository _surveySessionRepository;
        protected IUserRepository _userRepository;
        protected IVoterRepository _voterRepository;
        protected ITokenRepository _tokenRepository;
        
        
        
        public RepositoryHolder()
        {
            _context = new ESurveyEntities();
        }

        public void Dispose()
        {
            _context.Dispose();
        }

        public IAnsweredQuestionsOptionsRepository AnsweredQuestionsOptionsRepository
        {
            get
            {
                if(_answeredQuestionsOptionsRepository == null)
                    _answeredQuestionsOptionsRepository = new AnsweredQuestionsOptionsRepository(_context);
                return _answeredQuestionsOptionsRepository;
            }
        }

        public IAnsweredQuestionsRepository AnsweredQuestionsRepository
        {
            get
            {
                if(_answeredQuestionsRepository == null)
                    _answeredQuestionsOptionsRepository = new AnsweredQuestionsOptionsRepository(_context);
                return _answeredQuestionsRepository;
            }
        }

        public IAnswerRepository AnswerRepository
        {
            get
            {
                if(_answerRepository == null)
                    _answerRepository = new AnswerRepository(_context);
                return _answerRepository;
            }
        }

        public IQuestionRepository QuestionRepository
        {
            get
            {
                if(_questionRepository == null)
                    _questionRepository = new QuestionRepository(_context);
                return _questionRepository;
            }
        }

        public ISurveyRepository SurveyRepository
        {
            get
            {
                if(_surveyRepository == null)
                    _surveyRepository = new SurveyRepository(_context);
                return _surveyRepository;
            }
        }

        public ISurveySessionRepository SurveySessionRepository
        {
            get
            {
                if(_surveySessionRepository == null)
                    _surveySessionRepository = new SurveySessionRepository(_context);
                return _surveySessionRepository;
            }
        }

        public IUserRepository UserRepository
        {
            get
            {
                if(_userRepository == null)
                    _userRepository = new UserRepository(_context);
                return _userRepository;
            }
        }

        public IVoterRepository VoterRepository
        {
            get
            {
                if(_voterRepository == null)
                    _voterRepository = new VoterRepository(_context);
                return _voterRepository;
            }
        }


        public ITokenRepository TokenRepository
        {
            get
            {
                if (_tokenRepository == null)
                    _tokenRepository = new TokenRepository(_context);
                return _tokenRepository;
            }
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public void SaveChanges()
        {
            _context.SaveChanges(); 
        }
    }
}
