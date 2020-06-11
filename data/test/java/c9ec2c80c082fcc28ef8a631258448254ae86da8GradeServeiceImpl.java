package br.cad.service.academico.impl;

import javax.faces.bean.ManagedProperty;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.cad.dao.academico.GradeDao;
import br.cad.model.academico.Grade;
import br.cad.service.academico.DisciplinaService;
import br.cad.service.academico.GradeService;
import br.cad.service.impl.AbstractService;
import br.cad.service.pessoa.DocenteService;

/**
 * 
 * @author WilliamRodrigues <br>
 *         {@link william.rodrigues@live.fae.edu}
 * 
 */
@Service("gradeService")
public class GradeServeiceImpl extends AbstractService<Grade, GradeDao> implements GradeService {

	/*
	 * *******************************************************************************************************************
	 * ***************************************************** Atributos****************************************************
	 * *******************************************************************************************************************
	 */

	@ManagedProperty("#{disciplinaService}")
	private DisciplinaService disciplinaService;
	@ManagedProperty("#{docenteService}")
	private DocenteService docenteService;

	/*
	 * *******************************************************************************************************************
	 * ***************************************************** GETS E SETS *************************************************
	 * *******************************************************************************************************************
	 */

	public DisciplinaService getDisciplinaService() {
		return disciplinaService;
	}

	@Autowired
	public void setDisciplinaService(DisciplinaService disciplinaService) {
		this.disciplinaService = disciplinaService;
	}

	public DocenteService getDocenteService() {
		return docenteService;
	}

	@Autowired
	public void setDocenteService(DocenteService docenteService) {
		this.docenteService = docenteService;
	}
	/*
	 * *******************************************************************************************************************
	 * ***************************************************** Metodos *****************************************************
	 * *******************************************************************************************************************
	 */

}
