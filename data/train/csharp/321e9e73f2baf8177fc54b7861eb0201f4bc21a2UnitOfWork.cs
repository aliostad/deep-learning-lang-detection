using System;
using DbModel;

namespace DataAccess
{
	public class UnitOfWork : IDisposable
	{
		private RequestRepository requestRepository;
		private RequestRowRepository requestRowRepository;
		private StatesRepository stateRepository;
		private UsersRepository userRepository;
		private PostsRepository postRepository;
		private BuyersRepository buyersRepository;
		private GoodsRepository goodsRepository;
		private LeftoversRepository leftoversRepository;
		private PostofficeRepository postofficeRepository;
		private WarehousesRepository warehousesRepository;

		private DataContext db;
		private bool disposed = false;

		public UnitOfWork()
		{
			db = new DataContext();
			db.Configuration.LazyLoadingEnabled = false;
			//if (db.DatabaseExists())
			//	db.DeleteDatabase();
			//db.CreateDatabase();
			//initializeDb();
		}

		public UnitOfWork(string connectionString)
		{
			db = new DataContext();
		}

		public RequestRepository Requests
		{
			get
			{
				if (requestRepository == null)
					requestRepository = new RequestRepository(db);
				return requestRepository;
			}
		}

		public RequestRowRepository RequestRows
		{
			get
			{
				if (requestRowRepository == null)
					requestRowRepository = new RequestRowRepository(db);
				return requestRowRepository;
			}
		}

		public StatesRepository States
		{
			get
			{
				if (stateRepository == null)
					stateRepository = new StatesRepository(db);
				return stateRepository;
			}
		}

		public UsersRepository Users
		{
			get
			{
				if (userRepository == null)
					userRepository = new UsersRepository(db);
				return userRepository;
			}
		}

		public PostsRepository Posts
		{
			get
			{
				if (postRepository == null)
					postRepository = new PostsRepository(db);
				return postRepository;
			}
		}

		public BuyersRepository Buyers
		{
			get
			{
				if (buyersRepository == null)
					buyersRepository = new BuyersRepository(db);
				return buyersRepository;
			}
		}

		public GoodsRepository Goods
		{
			get
			{
				if (goodsRepository == null)
					goodsRepository = new GoodsRepository(db);
				return goodsRepository;
			}
		}

		public LeftoversRepository Leftovers
		{
			get
			{
				if (leftoversRepository == null)
					leftoversRepository = new LeftoversRepository(db);
				return leftoversRepository;
			}
		}

		public PostofficeRepository Postoffices
		{
			get
			{
				if (postofficeRepository == null)
					postofficeRepository=new PostofficeRepository(db);
					return postofficeRepository;
			}
		}

		public WarehousesRepository Warehouses
		{
			get
			{
				if (warehousesRepository == null)
					warehousesRepository = new WarehousesRepository(db);
					return warehousesRepository;
			}
		}

		public virtual void Dispose(bool disposing)
		{
			if (!this.disposed)
			{
				if (disposing)
				{
					db.Dispose();
				}
				this.disposed = true;
			}
		}

		public void SaveChanges()
		{
			db.SaveChanges();
		}

		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}
	}
}
