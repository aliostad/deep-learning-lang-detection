using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccess.Interfacies;
using DataAccess.Interfacies.Entities;
using DataAccess.Interfacies.Interfacies;
using ORMLibrary;

namespace DataAccessLibrary.Repository
{
    public class EFUnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext context;
        private bool disposed = false;
        private AuthorRepository authorRepository;
        private BookRepository bookRepository;
        private CollectionRepository collectionRepository;
        private UserRepository userRepository;
        private ListRepository listRepository;
        private TagRepository tagRepository;
        private RoleRepository roleRepository;
        private GenreRepository genreRepository;
        private CommentRepository commentRepository;
        private ContentRepository contentRepository;
        private ReviewRepository reviewRepository;
        private LikeRepository likeRepository;

        public IAuthorRepository Authors => authorRepository ?? (authorRepository = new AuthorRepository(context));
        public IBookRepository Books => bookRepository ?? (bookRepository = new BookRepository(context));
        public ICollectionRepository Collections => collectionRepository ?? (collectionRepository = new CollectionRepository(context));
        public ICommentRepository Comments => commentRepository ?? (commentRepository = new CommentRepository(context));
        public IContentRepository Contents => contentRepository ?? (contentRepository = new ContentRepository(context));
        public IGenreRepository Genres => genreRepository ?? (genreRepository = new GenreRepository(context));
        public ILikeRepository Likes => likeRepository ?? (likeRepository = new LikeRepository(context));
        public IListRepository Lists => listRepository ?? (listRepository = new ListRepository(context));
        public ITagRepository Tags => tagRepository ?? (tagRepository = new TagRepository(context));
        public IUserRepository Users => userRepository ?? (userRepository = new UserRepository(context));
        public IReviewRepository Reviews => reviewRepository ?? (reviewRepository = new ReviewRepository(context));
        public IRoleRepository Roles => roleRepository ?? (roleRepository = new RoleRepository(context));

        public EFUnitOfWork(DatabaseContext context)
        {
            this.context = context;
        }

        ~EFUnitOfWork()
        {
            Dispose();
        }
        public void Dispose()
        {
            if (!disposed)
            {
                context.Dispose();
                GC.SuppressFinalize(this);
            }
            else
                throw new ObjectDisposedException(nameof(EFUnitOfWork), "Object was disposed yet.");
        }

        public void Save()
        {
            context.SaveChanges();
        }

        public async Task SaveAsync()
        {
            await context.SaveChangesAsync();
        }
    }
}
