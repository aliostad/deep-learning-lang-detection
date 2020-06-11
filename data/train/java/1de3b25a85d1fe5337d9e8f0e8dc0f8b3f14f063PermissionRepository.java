package cn.imethan.repository.jpa.security;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import cn.imethan.entity.security.Permission;


/**
 * PermissionRepository.java
 *
 * @author Ethan Wong
 * @time 2014年3月16日下午4:59:32
 */
@Repository
public interface PermissionRepository  extends JpaRepository<Permission, Long>,CrudRepository<Permission, Long> {

}


