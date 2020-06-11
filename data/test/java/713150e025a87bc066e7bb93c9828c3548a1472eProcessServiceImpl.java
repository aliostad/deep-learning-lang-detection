package br.com.teste.jsdm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.com.teste.jsdm.dao.ProcessDao;
import br.com.teste.jsdm.model.Process;
import br.com.teste.jsdm.service.ProcessService;

// TODO: Auto-generated Javadoc
/**
 * DOCUMENT ME!.
 *
 * @author Welson
 */
@Service("processService")
public class ProcessServiceImpl extends ServiceImpl implements ProcessService {

	/** A constante serialVersionUID. */
	private static final long serialVersionUID = -8482465059833747350L;
	
	/** process dao. */
	@Autowired
	private ProcessDao processDao;

	/* (non-Javadoc)
	 * @see br.com.teste.jsdm.service.ProcessService#save(br.com.teste.jsdm.model.Process)
	 */
	@Override
	public void save(Process process) {
		process.setStatus(1);
		processDao.save(process);
	}
	
	/* (non-Javadoc)
	 * @see br.com.teste.jsdm.service.ProcessService#findByFilter(br.com.teste.jsdm.model.Process)
	 */
	@Override
	public List<Process> findByFilter(Process process) {
		return processDao.findByFilter(process);
	}

}
