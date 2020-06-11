package ro.sdl.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import ro.sdl.domain.User;

import java.util.Collection;

@Repository
public interface UserRepository extends CrudRepository<User, Integer> {

    User load(long userId) throws RepositoryException;

    Collection<User> getUsers() throws RepositoryException;

    void add(User user) throws RepositoryException;

    void update(User user) throws RepositoryException;

    void delete(long userId) throws RepositoryException;
}
