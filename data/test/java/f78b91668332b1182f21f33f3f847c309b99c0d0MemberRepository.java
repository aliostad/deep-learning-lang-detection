package mum.universitystore.repository;

import mum.universitystore.model.Member;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends CrudRepository<Member, Long> {

//	@Query("SELECT m FROM Member m WHERE id=:memberNumber")
//	public Member findByMemberNumber(@Param("memberNumber") Long id);
}
