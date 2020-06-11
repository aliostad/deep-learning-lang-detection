package common.demo.repository;

import common.demo.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

/**
 * Interface {@code UserRepository}, provides CRUD and other additional methods interaction with
 * database ({@code UserEntity} class representation)
 *
 * @see org.springframework.data.repository.CrudRepository
 * @see common.demo.repository.UserRepositoryCustom
 *
 * @author Alex Vengrovskiy
 */
@Repository
public interface UserJpaRepository extends JpaRepository<UserEntity, Long>, UserRepositoryCustom {

}
