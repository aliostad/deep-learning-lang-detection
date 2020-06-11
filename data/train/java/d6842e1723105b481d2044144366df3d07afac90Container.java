package com.xeasony;

import com.xeasony.repository.AuthorRepository;
import com.xeasony.repository.BookRepository;
import com.xeasony.repository.MagazineRepository;
import com.xeasony.service.AuthorService;
import com.xeasony.service.BookService;
import com.xeasony.service.MagazineService;

public class Container {
    private static Container instance = new Container();

    private AuthorRepository authorRepository;
    private BookRepository bookRepository;
    private MagazineRepository magazineRepository;

    private AuthorService authorService;
    private BookService bookService;
    private MagazineService magazineService;

    private Container() {
    }

    public static Container getInstance() {
        return instance;
    }

    public AuthorRepository getAuthorRepository() {
        if (authorRepository == null) {
            authorRepository = new AuthorRepository();
        }
        return authorRepository;
    }

    public void setAuthorRepository(AuthorRepository authorRepository) {
        this.authorRepository = authorRepository;
    }

    public BookRepository getBookRepository() {
        if (bookRepository == null) {
            bookRepository = new BookRepository();
        }
        return bookRepository;
    }

    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public MagazineRepository getMagazineRepository() {
        if (magazineRepository == null) {
            magazineRepository = new MagazineRepository();
        }
        return magazineRepository;
    }

    public void setMagazineRepository(MagazineRepository magazineRepository) {
        this.magazineRepository = magazineRepository;
    }

    public AuthorService getAuthorService() {
        if (authorService == null) {
            this.authorService = new AuthorService(getAuthorRepository());
        }
        return authorService;
    }

    public void setAuthorService(AuthorService authorService) {
        this.authorService = authorService;
    }

    public BookService getBookService() {
        if (bookService == null) {
            this.bookService = new BookService(getBookRepository(), getAuthorService());
        }
        return bookService;
    }

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }

    public MagazineService getMagazineService() {
        if (magazineService == null) {
            magazineService = new MagazineService(getMagazineRepository(), getAuthorService());
        }
        return magazineService;
    }

    public void setMagazineService(MagazineService magazineService) {
        this.magazineService = magazineService;
    }
}
