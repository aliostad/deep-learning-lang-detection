using DataAccess.Repository;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
   public class UnitOfWork
    {
        LMSTSContext _context;
        public UnitOfWork()
        {
            _context = new LMSTSContext();
        }
        AnswerRepository _answerRepository;
        public AnswerRepository AnswerRepository
        {
            get
            {
                if (_answerRepository == null)
                {
                    _answerRepository = new AnswerRepository(_context);
                }
                return _answerRepository;
            }
        }

        BranchRepository _branchRepository;
        public BranchRepository BranchRepository
        {
            get
            {
                if (_branchRepository == null)
                {
                    _branchRepository = new BranchRepository(_context);
                }
                return _branchRepository;
            }
        }

        CommentRepository _commentRepository;
        public CommentRepository CommentRepository
        {
            get
            {
                if (_commentRepository == null)
                {
                    _commentRepository = new CommentRepository(_context);
                }
                return _commentRepository;
            }
        }

        ContentRepository _contentRepository;
        public ContentRepository ContentRepository
        {
            get
            {
                if (_contentRepository == null)
                {
                    _contentRepository = new ContentRepository(_context);
                }
                return _contentRepository;
            }
        }

        EducationBranchRepository _educationBranchRepository;
        public EducationBranchRepository EducationBranchRepository
        {
            get
            {
                if (_educationBranchRepository == null)
                {
                    _educationBranchRepository = new EducationBranchRepository(_context);
                }
                return _educationBranchRepository;
            }
        }

        EducationGroupRepository _educationGroupRepository;
        public EducationGroupRepository EducationGroupRepository
        {
            get
            {
                if (_educationGroupRepository == null)
                {
                    _educationGroupRepository = new EducationGroupRepository(_context);
                }
                return _educationGroupRepository;
            }
        }

        EducationGroupStudentRepository _educationGroupStudentRepository;
        public EducationGroupStudentRepository EducationGroupStudentRepository
        {
            get
            {
                if (_educationGroupStudentRepository == null)
                {
                    _educationGroupStudentRepository = new EducationGroupStudentRepository(_context);
                }
                return _educationGroupStudentRepository;
            }
        }

        GenderRepository _genderRepository;
        public GenderRepository GenderRepository
        {
            get
            {
                if (_genderRepository == null)
                {
                    _genderRepository = new GenderRepository(_context);
                }
                return _genderRepository;
            }
        }
        HomeworkDeliveryRepository _homeworkDeliveryRepository;
        public HomeworkDeliveryRepository HomeworkDeliveryRepository
        {
            get
            {
                if (_homeworkDeliveryRepository == null)
                {
                    _homeworkDeliveryRepository = new HomeworkDeliveryRepository(_context);
                }
                return _homeworkDeliveryRepository;
            }
        }
        HomeworkRepository _homeworkRepository;
        public HomeworkRepository HomeworkReipository
        {
            get
            {
                if (_homeworkRepository == null)
                {
                    _homeworkRepository = new HomeworkRepository(_context);
                }
                return _homeworkRepository;
            }
        }

        HomeworkReturnRepository _homeworkReturnRepository;
        public HomeworkReturnRepository HomeworkReturnRepository
        {
            get
            {
                if (_homeworkReturnRepository == null)
                {
                    _homeworkReturnRepository = new HomeworkReturnRepository(_context);
                }
                return _homeworkReturnRepository;
            }
        }

        LoginRepository _loginRepository;
        public LoginRepository LoginRepository
        {
            get
            {
                if (_loginRepository == null)
                {
                    _loginRepository = new LoginRepository(_context);
                }
                return _loginRepository;
            }
        }
        LogPageRepository _logPageRepository;
        public LogPageRepository LogPageRepository
        {
            get
            {
                if (_logPageRepository == null)
                {
                    _logPageRepository = new LogPageRepository(_context);
                }
                return _logPageRepository;
            }
        }

        LogSystemLoginRepository _logSystemLoginRepository;
        public LogSystemLoginRepository LogSystemLoginRepository
        {
            get
            {
                if (_logSystemLoginRepository == null)
                {
                    _logSystemLoginRepository = new LogSystemLoginRepository(_context);
                }
                return _logSystemLoginRepository;
            }
        }
        MessageGroupRepository _messageGroupRepository;
        public MessageGroupRepository MessageGroupRepository
        {
            get
            {
                if (_messageGroupRepository == null)
                {
                    _messageGroupRepository = new MessageGroupRepository(_context);
                }
                return _messageGroupRepository;
            }
        }

        MessageGroupUserRepository _messageGroupUserRepository;
        public MessageGroupUserRepository MessageGroupUserRepository
        {
            get
            {
                if (_messageGroupUserRepository == null)
                {
                    _messageGroupUserRepository = new MessageGroupUserRepository(_context);
                }
                return _messageGroupUserRepository;
            }
        }

        MessageRepository _messageRepository;
        public MessageRepository MessageRepository
        {
            get
            {
                if (_messageRepository == null)
                {
                    _messageRepository = new MessageRepository(_context);
                }
                return _messageRepository;
            }
        }

        OptionRepository _optionRepository;
        public OptionRepository OptionRepository
        {
            get
            {
                if (_optionRepository == null)
                {
                    _optionRepository = new OptionRepository(_context);
                }
                return _optionRepository;
            }
        }

        QuestionRepository _questionRepository;
        public QuestionRepository QuestionRepository
        {
            get
            {
                if (_questionRepository == null)
                {
                    _questionRepository = new QuestionRepository(_context);
                }
                return _questionRepository;
            }
        }

        ReturnTypeRepository _returnTypeRepository;
        public ReturnTypeRepository ReturnTypeRepository
        {
            get
            {
                if (_returnTypeRepository == null)
                {
                    _returnTypeRepository = new ReturnTypeRepository(_context);
                }
                return _returnTypeRepository;
            }
        }

        StudentRepository _studentRepository;
        public StudentRepository StudentRepository
        {
            get
            {
                if (_studentRepository == null)
                {
                    _studentRepository = new StudentRepository(_context);
                }
                return _studentRepository;
            }
        }

        SubjectRepository _subjectRepository;
        public SubjectRepository SubjectRepository
        {
            get
            {
                if (_subjectRepository == null)
                {
                    _subjectRepository = new SubjectRepository(_context);
                }
                return _subjectRepository;
            }
        }

        TitleRepository _titleRepository;
        public TitleRepository TitleRepository
        {
            get
            {
                if (_titleRepository == null)
                {
                    _titleRepository = new TitleRepository(_context);
                }
                return _titleRepository;
            }
        }

        TopicRepository _topicRepository;
        public TopicRepository TopicRepository
        {
            get
            {
                if (_topicRepository == null)
                {
                    _topicRepository = new TopicRepository(_context);
                }
                return _topicRepository;
            }
        }

        TrainerRepository _trainerRepository;
        public TrainerRepository TrainerRepository
        {
            get
            {
                if (_trainerRepository == null)
                {
                    _trainerRepository = new TrainerRepository(_context);
                }
                return _trainerRepository;
            }
        }

        DbContextTransaction _tran;
        public bool ApplyChanges()
        {
            bool isSuccess = false;


            _tran = _context.Database.BeginTransaction(System.Data.IsolationLevel.ReadCommitted);

            try
            {
                _context.SaveChanges();
                _tran.Commit();
                isSuccess = true;

            }
            catch (Exception)
            {
                _tran.Rollback();
                isSuccess = false;
                throw;
            }
            finally
            {
                _tran.Dispose();
            }
            return isSuccess;


        }
    }
}
