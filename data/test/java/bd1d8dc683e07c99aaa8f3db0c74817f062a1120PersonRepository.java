package com.szkingdom.ssm.repo;

import com.szkingdom.ssm.domain.Person;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.stereotype.Repository;

/**
 * Created by phoenix on 2017/3/31.
 */
/*public interface PersonRepository extends CassandraRepository<Person> {*/
    //org.springframework.data.cassandra.repository.support.CassandraRepositoryFactoryBean

@Repository
public interface PersonRepository extends CrudRepository<Person, String>{



}
