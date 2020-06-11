package hamlog.repository;

import hamlog.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 * @author Adrian Scripcă
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

	@Query("SELECT u FROM User u WHERE lower(u.callsign) = lower(:callsign)")
	User findByCallsign(@Param("callsign") String callsign);
}