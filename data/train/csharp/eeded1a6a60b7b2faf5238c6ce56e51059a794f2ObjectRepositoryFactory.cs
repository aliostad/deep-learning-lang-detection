using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Lab1.Library.DataAccess
{
	public class ObjectRepositoryFactory : IRepositoryFactory
	{
		public ReaderRepository CreateReaderRepository()
		{
			return new ReaderObjectRepository();
		}

		public BookRepository CreateBookRepository(LibraryDepartmentRepository libraryDepartmentRepository)
		{
			return new BookObjectRepository(libraryDepartmentRepository);
		}

		public LibrarianRepository CreateLibrarianRepository(LibraryDepartmentRepository libraryDepartmentRepository)
		{
			return new LibrarianObjectRepository(libraryDepartmentRepository);
		}

		public LibraryDepartmentRepository CreateLibraryDepartmentRepository()
		{
			return new LibraryDepartmentObjectRepository();
		}

		public OrderRepository CreateOrderRepository(ReaderRepository readerRepository, BookRepository bookRepository, 
			LibraryDepartmentRepository libraryDepartmentRepository, LibrarianRepository librarianRepository)
		{
			return new OrderObjectRepository(readerRepository, bookRepository, libraryDepartmentRepository, librarianRepository);
		}
	}
}
