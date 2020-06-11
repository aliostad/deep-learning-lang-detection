using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Lab1.Library.DataAccess
{
	public class Repository
	{
		public ReaderRepository ReaderRepository { get; private set; }

		public BookRepository BookRepository { get; private set; }

		public LibrarianRepository LibrarianRepository { get; private set; }

		public LibraryDepartmentRepository LibraryDepartmentRepository { get; private set; }

		public OrderRepository OrderRepository { get; private set; }

		public Repository(IRepositoryFactory repositoryFactory)
		{
			ReaderRepository = repositoryFactory.CreateReaderRepository();
			LibraryDepartmentRepository = repositoryFactory.CreateLibraryDepartmentRepository();
			BookRepository = repositoryFactory.CreateBookRepository(LibraryDepartmentRepository);
			LibrarianRepository = repositoryFactory.CreateLibrarianRepository(LibraryDepartmentRepository);
			OrderRepository = repositoryFactory.CreateOrderRepository(ReaderRepository, BookRepository, LibraryDepartmentRepository, LibrarianRepository);
		}
	}
}
