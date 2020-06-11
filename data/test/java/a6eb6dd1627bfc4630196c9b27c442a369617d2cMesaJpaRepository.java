package com.springboot.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.springboot.model.Mesa;

@Repository
public interface MesaJpaRepository extends CrudRepository<Mesa, Long>, JpaRepository<Mesa,Long>{

	@Query("SELECT p FROM Mesa p WHERE p.cod_mesa = :cod_mesa ")
	Mesa obtenerMesaPorCodigo(@Param("cod_mesa") String cod_mesa);
}
