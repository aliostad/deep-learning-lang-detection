package br.ufrn.dimap.consiste.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface RepositoryRepository extends JpaRepository<RepositoryEntity, Integer>{

	@Query("SELECT r FROM RepositoryEntity r WHERE r.user.id = ?1")
	public List<RepositoryEntity> findAllByUser(Integer id);
	
	@Query("SELECT r FROM RepositoryEntity r INNER JOIN r.domains d WHERE d.name = ?1")
	public List<RepositoryEntity> findAllByDomain(String domainName);
	
}
