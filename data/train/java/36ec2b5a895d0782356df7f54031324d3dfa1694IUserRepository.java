package edu.mum.tmsystem.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import edu.mum.tmsystem.domain.User;

@Repository
public interface IUserRepository extends CrudRepository<User, Long> {
	
	@Query("SELECT u FROM User u WHERE u.username = :username")
	public User getUserFromUsername(@Param("username") String username);

}
