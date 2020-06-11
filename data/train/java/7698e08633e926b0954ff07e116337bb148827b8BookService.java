package nl.jworks.epub.service;


import nl.jworks.epub.domain.Book;
import nl.jworks.epub.persistence.spring.BinaryRepository;
import nl.jworks.epub.persistence.spring.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;

@Service
public class BookService {

    private BookRepository bookRepository;
    private BinaryRepository binaryRepository;

    @Autowired
    public BookService(BookRepository bookRepository,
                       BinaryRepository binaryRepository) {
        this.bookRepository = bookRepository;
        this.binaryRepository = binaryRepository;
    }

    public void save(Book book) {
        binaryRepository.save(Arrays.asList(book.getCover(), book.getEpub()));

        bookRepository.save(book);
    }
}
