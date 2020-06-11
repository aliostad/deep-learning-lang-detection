using MEASModel.DBModel;
using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEASDAL
{
    public class UnitOfWork
    {
        private MEASEntities _edm = null;
        private UserRepository _userRepository = null;
        private TopicRepository _topicRepository = null;
        private NewsRepository _newsRepository = null;
        private CourseRepository _courseRepository = null;
        public UnitOfWork()
        {
            _edm = new MEASEntities();
        }

        public UserRepository UserRepository
        {
            get
            {
                if (_userRepository == null)
                {
                    _userRepository = new UserRepository(_edm);
                }

                return _userRepository;
            }
        }

        public TopicRepository TopicRepository
        {
            get
            {
                if (_topicRepository == null)
                {
                    _topicRepository = new TopicRepository(_edm);
                }

                return _topicRepository;
            }
        }

        public NewsRepository NewsRepository
        {
            get
            {
                if (_newsRepository == null)
                {
                    _newsRepository = new NewsRepository(_edm);
                }

                return _newsRepository;
            }
        }

        public CourseRepository CourseRepository
        {
            get
            {
                if(_courseRepository==null)
                {
                    _courseRepository = new CourseRepository(_edm);
                }
                return _courseRepository;
            }
        }

        public int Commit()
        {
            try
            {
                return _edm.SaveChanges();
            }
            catch (DbEntityValidationException dbEx)
            {
                return 0;
            }
        }
    }
}
