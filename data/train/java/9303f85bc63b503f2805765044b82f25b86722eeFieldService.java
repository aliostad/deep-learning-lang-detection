package cn.ilongfei.quickweb.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.ilongfei.quickweb.model.Field;
import cn.ilongfei.quickweb.repository.FieldRepository;


@Service
public class FieldService extends AbstractService<Field>{
	FieldRepository fieldRepository;
	@Autowired
	public void setRoleReposity(FieldRepository fieldRepository){
		repository = fieldRepository;
		this.fieldRepository = fieldRepository;
	} 

}
