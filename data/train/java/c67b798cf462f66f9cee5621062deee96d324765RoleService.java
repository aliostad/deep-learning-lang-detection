package cn.ilongfei.quickweb.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.ilongfei.quickweb.model.Role;
import cn.ilongfei.quickweb.repository.RoleRepository;


@Service
public class RoleService extends AbstractService<Role>{
	RoleRepository roleRepository;
	@Autowired
	public void setRoleReposity(RoleRepository roleRepository){
		repository = roleRepository;
		this.roleRepository = roleRepository; 
	}
	
	
}
