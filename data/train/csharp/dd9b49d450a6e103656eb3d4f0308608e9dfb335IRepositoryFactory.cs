using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Lab1.Library.DataAccess
{
	public interface IRepositoryFactory
	{
		ReaderRepository CreateReaderRepository();
		BookRepository CreateBookRepository(LibraryDepartmentRepository libraryDepartmentRepository);
		LibrarianRepository CreateLibrarianRepository(LibraryDepartmentRepository libraryDepartmentRepository);
		LibraryDepartmentRepository CreateLibraryDepartmentRepository();
		OrderRepository CreateOrderRepository(ReaderRepository readerRepository, BookRepository bookRepository,
			LibraryDepartmentRepository libraryDepartmentRepository, LibrarianRepository librarianRepository);
	}
}
