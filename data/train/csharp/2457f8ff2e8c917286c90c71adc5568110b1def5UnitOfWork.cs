using System;

namespace BeerHouse.Database {
    public class UnitOfWork : IDisposable {
        private readonly BeerHouseEntities _context = new BeerHouseEntities();
        private Repository<Album> _albumRepository;
        private Repository<Article> _articleRepository;
        private Repository<Category> _categoryRepository;
        private Repository<Comment> _commentRepository;
        private Repository<Department> _departmentRepository;
        private bool _disposed;
        private Repository<Event> _eventRepository;
        private Repository<Forum> _forumRepository;
        private Repository<Newsletter> _newsletterRepository;
        private Repository<OrderItem> _orderItemRepository;
        private Repository<Order> _orderRepository;
        private Repository<OrderStatus> _orderStatusRepository;
        private Repository<PollOption> _pollOptionRepository;
        private Repository<Poll> _pollRepository;
        private Repository<Post> _postRepository;
        private Repository<Product> _productRepository;
        private Repository<ShippingMethod> _shippingMethodRepository;

        public Repository<Article> ArticleRepository
            => _articleRepository ??
               (_articleRepository = new Repository<Article>( _context ));

        public Repository<Album> AlbumRepository
            => _albumRepository ??
               (_albumRepository = new Repository<Album>( _context ));

        public Repository<Category> CategoryRepository
            => _categoryRepository ??
               (_categoryRepository = new Repository<Category>( _context ));

        public Repository<Comment> CommentRepository
            => _commentRepository ??
               (_commentRepository = new Repository<Comment>( _context ));

        public Repository<Department> DepartmentRepository
            => _departmentRepository ??
               (_departmentRepository = new Repository<Department>( _context ));

        public Repository<Event> EventRepository
            => _eventRepository ??
               (_eventRepository = new Repository<Event>( _context ));

        public Repository<Forum> ForumRepository
            => _forumRepository ??
               (_forumRepository = new Repository<Forum>( _context ));

        public Repository<Newsletter> NewsletterRepository
            => _newsletterRepository ??
               (_newsletterRepository = new Repository<Newsletter>( _context ));

        public Repository<Order> OrderRepository
            => _orderRepository ??
               (_orderRepository = new Repository<Order>( _context ));

        public Repository<OrderItem> OrderItemRepository
            => _orderItemRepository ??
               (_orderItemRepository = new Repository<OrderItem>( _context ));

        public Repository<OrderStatus> OrderStatusRepository
            => _orderStatusRepository ??
               (_orderStatusRepository = new Repository<OrderStatus>( _context ));

        public Repository<Poll> PollRepository
            => _pollRepository ??
               (_pollRepository = new Repository<Poll>( _context ));

        public Repository<PollOption> PollOptionRepository
            => _pollOptionRepository ??
               (_pollOptionRepository = new Repository<PollOption>( _context ));

        public Repository<Post> PostRepository
            => _postRepository ??
               (_postRepository = new Repository<Post>( _context ));

        public Repository<Product> ProductRepository
            => _productRepository ??
               (_productRepository = new Repository<Product>( _context ));

        public Repository<ShippingMethod> ShippingMethodRepository
            => _shippingMethodRepository ??
               (_shippingMethodRepository = new Repository<ShippingMethod>( _context ));

        public void Dispose () {
            Dispose( true );
            GC.SuppressFinalize( this );
        }

        public void SaveChanges () {
            _context.SaveChanges();
        }

        protected virtual void Dispose ( bool disposing ) {
            if ( !_disposed ) {
                if ( disposing ) {
                    _context.Dispose();
                }
            }
            _disposed = true;
        }
    }
}