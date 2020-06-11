using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Lab1.Library.DataAccess
{
	public class TextRepositoryFactory : IRepositoryFactory
	{
		public ReaderRepository CreateReaderRepository()
		{
			return new ReaderTextRepository();
		}

		public BookRepository CreateBookRepository(LibraryDepartmentRepository libraryDepartmentRepository)
		{
			return new BookTextRepository(libraryDepartmentRepository);
		}

		public LibrarianRepository CreateLibrarianRepository(LibraryDepartmentRepository libraryDepartmentRepository)
		{
			return new LibrarianTextRepository(libraryDepartmentRepository);
		}

		public LibraryDepartmentRepository CreateLibraryDepartmentRepository()
		{
			return new LibraryDepartmentTextRepository();
		}

		public OrderRepository CreateOrderRepository(ReaderRepository readerRepository, BookRepository bookRepository, 
			LibraryDepartmentRepository libraryDepartmentRepository, LibrarianRepository librarianRepository)
		{
			return new OrderTextRepository(readerRepository, bookRepository, libraryDepartmentRepository, librarianRepository);
		}
	}
}
