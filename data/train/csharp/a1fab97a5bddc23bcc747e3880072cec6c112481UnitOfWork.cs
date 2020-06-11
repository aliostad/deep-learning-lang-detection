using System;
using BlogAppDAL.Entities;
using BlogAppDAL.Repository;

namespace BlogAppDAL.UoW
{
    public class UnitOfWork:IDisposable
    {
        private readonly BlogAppContext _context = null;
        private Repository<Blog> _blogRepository = null;
        private Repository<Category> _categoryRepository;
        private Repository<Comment> _commentRepository = null;
        private Repository<Role> _roleRepository = null;
        private Repository<User> _userRepository = null;
        private Repository<Author> _authorRepository = null;
        private Repository<Archives> _archivesRepository = null;
        private Repository<DailySentence> _dailySentenceRepository = null;
        private Repository<CommentReply> _commentReplyRepository = null;
        private Repository<SEO> _SEORepository = null;
        private Repository<SearchDetails> _SearchDetailsRepository = null;
        private Repository<SearchTotal> _SearchTotalsRepository = null;
        private Repository<Topic> _topicRepository = null;
        private Repository<TopicList> _topicListRepository = null;
        private Repository<TopicFirst> _topicFirstRepository = null;

        public UnitOfWork()
        {
            _context=new BlogAppContext();
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

        public Repository<Author> AuthorRepostiory
        {
            get { return _authorRepository ?? (_authorRepository = new Repository<Author>(_context)); }        
        }

        public Repository<Archives> ArchivesRepostiory
        {
            get { return _archivesRepository ?? (_archivesRepository = new Repository<Archives>(_context)); }
        }

        public Repository<DailySentence> DailySentenceRepostiory
        {
            get { return _dailySentenceRepository ?? (_dailySentenceRepository = new Repository<DailySentence>(_context)); }
        }

        public Repository<CommentReply> CommentReplyRepostiory
        {
            get { return _commentReplyRepository ?? (_commentReplyRepository = new Repository<CommentReply>(_context)); }
        }

        public Repository<SEO> SEORepostiory
        {
            get { return _SEORepository ?? (_SEORepository = new Repository<SEO>(_context)); }
        }


        public Repository<SearchDetails> SearchDetailsRepository
        {
            get { return _SearchDetailsRepository ?? (_SearchDetailsRepository = new Repository<SearchDetails>(_context)); }
        }

        public Repository<SearchTotal> SearchTotalRepository
        {
            get { return _SearchTotalsRepository ?? (_SearchTotalsRepository = new Repository<SearchTotal>(_context)); }
        }

        public Repository<Topic> TopicRepository
        {
            get { return _topicRepository ?? (_topicRepository = new Repository<Topic>(_context)); }
        }

        public Repository<TopicList> TopicListRepository
        {
            get { return _topicListRepository ?? (_topicListRepository = new Repository<TopicList>(_context)); }
        }

        public Repository<TopicFirst> TopicFirstRepository
        {
            get { return _topicFirstRepository ?? (_topicFirstRepository = new Repository<TopicFirst>(_context)); }
        }

        public void SaveChanges()
        {
            _context.SaveChanges();
        }


        public void Dispose()
        {
            _context.Dispose();
        }
    }
}
