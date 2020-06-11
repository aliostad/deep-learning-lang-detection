package gr.bytecode.exceptionhandling.rest;

import gr.bytecode.exceptionhandling.domain.Book;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.stereotype.Repository;

/**
 * A {@link Repository} of {@link Book} Resources
 * 
 * @author Dimi Balaouras
 */
@Repository
@RepositoryRestResource(collectionResourceRel = "books", path = "books")
interface BookRepository extends PagingAndSortingRepository<Book, Long> {

}
