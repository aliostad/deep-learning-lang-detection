package cn.ilongfei.quickweb.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.ilongfei.quickweb.model.Module;
import cn.ilongfei.quickweb.repository.ModuleRepository;


@Service
public class ModuleService extends AbstractService<Module>{
	ModuleRepository moduleRepository;
	@Autowired
	public void setRoleReposity(ModuleRepository moduleRepository){
		repository = moduleRepository;
		this.moduleRepository = moduleRepository;
	} 

}
