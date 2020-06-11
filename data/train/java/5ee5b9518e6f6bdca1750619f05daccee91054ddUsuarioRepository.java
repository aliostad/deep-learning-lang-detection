package br.com.wkgcosmeticos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import br.com.wkgcosmeticos.entidades.Usuario;
@Repository
public interface UsuarioRepository extends JpaRepository<Usuario,Integer>{
	@Query("select u from Usuario u where u.login=:plogin")
	 Usuario buscarPorUsername (@Param ("plogin") String login);
}
