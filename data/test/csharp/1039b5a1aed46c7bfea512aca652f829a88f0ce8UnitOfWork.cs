using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Photocom.Contracts;
using Photocom.Contracts.Repositories;
using Photocom.DataLayer.Repositories;

namespace Photocom.DataLayer
{
    public class UnitOfWork : IUnitOfWork
    {
        protected PhotocomContext PhotocomContext;

        private ICategoryRepository _categoryRepository;
        private ICommentRepository _commentRepository;
        private IPermissionRepository _permissionRepository;
        private IPhotoRepository _photoRepository;
        private IPrivilegeRepository _privilegeRepository;
        private IUserRepository _userRepository;
        private ISessionRepository _sessionRepository;
        private ILikeRepository _likeRepository;

        public UnitOfWork()
        {
            _categoryRepository = null;
            _commentRepository = null;
            _permissionRepository = null;
            _photoRepository = null;
            _privilegeRepository = null;
            _userRepository = null;

            PhotocomContext = new PhotocomContext();
        }

        public void SaveChanges()
        {
            PhotocomContext.SaveChanges();
        }

        public ICategoryRepository CategoryRepository
        {
            get
            {
                if (_categoryRepository == null)
                {
                    _categoryRepository = new CategoryRepository(PhotocomContext);
                }
                return _categoryRepository;
            }
        }

        public ICommentRepository CommentRepository
        {
            get
            {
                if (_commentRepository == null)
                {
                    _commentRepository = new CommentRepository(PhotocomContext);
                }
                return _commentRepository;
            }
        }

        public IPermissionRepository PermissionRepository
        {
            get
            {
                if (_commentRepository == null)
                {
                    _commentRepository = new CommentRepository(PhotocomContext);
                }
                return _permissionRepository;
            }
        }

        public IPhotoRepository PhotoRepository
        {
            get
            {
                if (_photoRepository == null)
                {
                    _photoRepository = new PhotoRepository(PhotocomContext);
                }
                return _photoRepository;
            }
        }

        public IPrivilegeRepository PrivilegeRepository
        {
            get
            {
                if (_privilegeRepository == null)
                {
                    _privilegeRepository = new PrivilegeRepository(PhotocomContext);
                }
                return _privilegeRepository;
            }
        }

        public IUserRepository UserRepository
        {
            get
            {
                if (_userRepository == null)
                {
                    _userRepository = new UserRepository(PhotocomContext);
                }
                return _userRepository;
            }
        }

        public ISessionRepository SessionRepository
        {
            get
            {
                if (_sessionRepository == null)
                {
                    _sessionRepository = new SessionRepository(PhotocomContext);
                }
                return _sessionRepository;
            }
        }

        public ILikeRepository LikeRepository
        {
            get
            {
                if (_likeRepository == null)
                {
                    _likeRepository = new LikeRepository(PhotocomContext);
                }
                return _likeRepository;
            }
        }

        public void Dispose()
        {
            PhotocomContext.Dispose();
        }
    }
}
