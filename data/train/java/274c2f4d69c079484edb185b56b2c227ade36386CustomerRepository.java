package com.uf.fanfan.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.uf.fanfan.entity.Customer;
@Repository
public interface CustomerRepository extends JpaRepository<Customer, Integer> {
	@Query("select t from Customer t where t.name=:name")
	public Customer findByName(@Param("name")String name);
}
