using ExamMaker.Models.Models;

namespace ExamMaker.Models.Repositories
{
    public class AppRepository
    {
        private IAppDataSource _dataSource;
        private Repository<User> _userRepository;
        private Repository<Exam> _examRepository;
        private Repository<ExamItem> _examItemRepository;
        private Repository<Option> _optionRepository;
        

        public AppRepository(IAppDataSource dataSource)
        {
            _dataSource = dataSource;
        }

        public Repository<User> UserRepository
        {
            get
            {
                if (_userRepository == null)
                {
                    _userRepository = new Repository<User>(_dataSource);
                }
                return _userRepository;
            }
        }

        public Repository<Exam> ExamRepository
        {
            get
            {
                if (_examRepository == null)
                {
                    _examRepository = new Repository<Exam>(_dataSource);
                }
                return _examRepository;
            }
        }

        public Repository<ExamItem> ExamItemRepository
        {
            get
            {
                if (_examItemRepository == null)
                {
                    _examItemRepository = new Repository<ExamItem>(_dataSource);
                }
                return _examItemRepository;
            }
        }

        public Repository<Option> OptionRepository
        {
            get
            {
                if (_optionRepository == null)
                {
                    _optionRepository = new Repository<Option>(_dataSource);
                }
                return _optionRepository;
            }
        }

        public void Save()
        {
            _dataSource.Save();
        }

    }
}
