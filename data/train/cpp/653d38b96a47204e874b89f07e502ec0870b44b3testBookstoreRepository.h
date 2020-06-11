#pragma once
#include <assert.h>
#include <vector>

#include "Book.h"
#include "BookstoreRepository.h"

void testaddBook() {
	BookstoreRepository repo;
	Book book = Book(1, "titlu", "author", "subiect", 2001);
	repo.addBook(book);
	assert(repo.getAll().size() == 1);

}
void testdeleteBook() {
	BookstoreRepository repo;
	Book book = Book(1, "titlu", "author", "subiect", 2001);
	repo.addBook(book);
	book = Book(2, "titlu2", "author31", "subiect", 2001);
	repo.addBook(book);
	repo.deleteBook(book);
	assert(repo.getAll().size() == 1);
}

void testupdateBook() {
	BookstoreRepository repo;
	Book book = Book(1, "titlu", "author", "subiect", 2001);
	repo.addBook(book);
	book = Book(1, "dadada", "dsdsa", "subiect", 2001);
	repo.updateBook(book);
	std::vector<Book> v = repo.getAll();
	assert(v.front().getTitle() == "dadada");
	assert(v.front().getAuthor() != "author");
	assert(v.front().getYear() == 2001);
}
void testeexistId() {
	BookstoreRepository repo;
	Book book = Book(1, "titlu", "author", "subiect", 2001);
	repo.addBook(book);
	book = Book(2, "titlu2", "author31", "subiect", 2001);
	repo.addBook(book);
	book = Book(3, "titlu2", "author31", "subiect", 2001);
	repo.addBook(book);
	assert(repo.existId(2) == true);
	assert(repo.existId(21) == false);
}

void testgetLastId() {
	BookstoreRepository repo;
	Book book1 = Book(1, "titlu", "author", "subject", 2011);
	repo.addBook(book1);
	book1 = Book(2, "titlu", "author", "subject", 2011);
	repo.addBook(book1);
	assert(repo.getLastId() == 3);
}

void testexistTitle() {
	BookstoreRepository repo;
	Book book1 = Book(1, "titlu", "author", "subject", 2011);
	repo.addBook(book1);
	assert(repo.existTitle("titlu").getId() == 1);
	assert(repo.existTitle("ada").getId() == -1);
}

void testgetById() {
	BookstoreRepository repo;
	Book book1 = Book(1, "titlu2", "author", "subject", 2011);
	repo.addBook(book1);
	book1 = Book(2, "titlu", "author", "subject", 2011);
	repo.addBook(book1);
	assert(repo.getById(2) == book1);
	assert((repo.getById(21) == book1) == false);
}

void testsortBy() {
	BookstoreRepository repo;
	Book b = Book(1, "Ion", "L. Rebreanu", "Roman", 1950);
	repo.addBook(b);
	b = Book(2, "Enigma Otiliei", "G. Calinescu", "Roman", 1900);
	repo.addBook(b);
	b = Book(3, "Moara cu Noroc", "I. Slavici", "Nuvela", 2011);
	repo.addBook(b);
	b = Book(4, "Mara	", "I. Slavici", "Nuvela", 1965);
	repo.addBook(b);
	b = Book(5, "Marile sperante", "C. Dickens", "Nuvela", 1800);
	repo.addBook(b);
	b = Book(6, "Mendebilul", "M. Cartarescu", "Roman", 2005);
	repo.addBook(b);
	b = Book(7, "Dama cu camelii", "A. Dumas", "Roman", 1800);
	repo.addBook(b);
	b = Book(8, "Decameronul", "G. Boccaccio", "Nuvela", 1200);
	repo.addBook(b);
	//title
	vector<Book> books = repo.sortBy(1);
	assert(books.size() == 8);
	b = Book(8, "Decameronul", "G. Boccaccio", "Nuvela", 1200);
	assert(books[1] == b);
	b = Book(6, "Mendebilul", "M. Cartarescu", "Roman", 2005);
	assert(books[6] == b);
	//year + subject
	books = repo.sortBy(3);
	b = Book(5, "Marile sperante", "C. Dickens", "Nuvela", 1800);
	//	cout << books[0] << endl;
	//	cout << books[1] << endl;
	//	cout << books[2] << endl;
	//	cout << books[3] << endl;
	//	cout << books[4] << endl;
	//	cout << books[5] << endl;
	//	cout << books[6] << endl;
	//	cout << books[7] << endl;
	assert(books[1] == b);
	b = Book(7, "Dama cu camelii", "A. Dumas", "Roman", 1800);
	assert(books[2] == b);
}

void testfilterBy() {
	BookstoreRepository repo;
	Book b = Book(1, "Ion", "L. Rebreanu", "Roman", 1950);
	repo.addBook(b);
	b = Book(2, "Enigma Otiliei", "G. Calinescu", "Roman", 1900);
	repo.addBook(b);
	b = Book(3, "Moara cu Noroc", "I. Slavici", "Nuvela", 2011);
	repo.addBook(b);
	b = Book(4, "Mara	", "I. Slavici", "Nuvela", 1965);
	repo.addBook(b);
	b = Book(5, "Marile sperante", "C. Dickens", "Nuvela", 1800);
	repo.addBook(b);
	b = Book(6, "Mendebilul", "M. Cartarescu", "Roman", 2005);
	repo.addBook(b);
	b = Book(7, "Dama cu camelii", "A. Dumas", "Roman", 1800);
	repo.addBook(b);
	b = Book(8, "Decameronul", "G. Boccaccio", "Nuvela", 1200);
	repo.addBook(b);
	//title
	vector<Book> books = repo.filterBy(1, "Ion");
	//	assert(books.size() == 1);
}

void testBookstoreRepository() {
	testaddBook();
	testdeleteBook();
	testupdateBook();
	testeexistId();
	testgetLastId();
	testexistTitle();
	testgetById();
	testsortBy();
	testfilterBy();
}