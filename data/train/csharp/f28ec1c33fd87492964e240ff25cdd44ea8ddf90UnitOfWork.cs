using BlogApp.DLL.Entities;
using BlogApp.DLL.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BlogApp.DLL.UoW
{
    public class UnitOfWork : IDisposable
    {
        private readonly BlogAppContext _context = null;
        private Repository<Blog> _blogRepository = null;
        private Repository<Category> _categoryRepository;
        private Repository<Comment> _commentRepository = null;
        private Repository<Role> _roleRepository = null;
        private Repository<User> _userRepository = null;

        public UnitOfWork(Repository<Blog> blogRepository, Repository<Category> categoryRepository, Repository<Comment> commentRepository, Repository<Role> roleRepository, Repository<User> userRepository)
        {
            _blogRepository = blogRepository;
            _categoryRepository = categoryRepository;
            _commentRepository = commentRepository;
            _roleRepository = roleRepository;
            _userRepository = userRepository;
            _context = new BlogAppContext();
        }

        public Repository<Blog> BlogRepository
        {
            get { return _blogRepository ?? (_blogRepository = new Repository<Blog>(_context)); }
        }
        public Repository<Category> CategoryRepository
        {
            get { return _categoryRepository ?? (_categoryRepository = new Repository<Category>(_context)); }
        }
        public Repository<Comment> CommentRepository
        {
            get { return _commentRepository ?? (_commentRepository = new Repository<Comment>(_context)); }
        }

        public Repository<Role> RoleRepository
        {
            get { return _roleRepository ?? (_roleRepository = new Repository<Role>(_context)); }
        }
        public Repository<User> UserRepository
        {
            get { return _userRepository ?? (_userRepository = new Repository<User>(_context)); }
        }
        public void SaveChanges()
        {
            _context.SaveChanges();
        }
        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }
}
