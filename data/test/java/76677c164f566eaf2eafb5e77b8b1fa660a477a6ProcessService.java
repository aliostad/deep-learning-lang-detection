package sk.erni.rap.jpa.service;

import sk.erni.rap.jpa.dao.ProcessDao;
import sk.erni.rap.jpa.model.Process;
import sk.erni.rap.jpa.model.ProcessAttribute;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * @author rap
 *         <p/>
 *         This is a simple webservice to test the ProcessDao
 *         <p/>
 *         Test path: http://localhost:8080/jpaTest/rs/process
 */
@Path("/process")
public class ProcessService {

	@Inject
	private ProcessDao processDao;

	@GET
	@Produces("text/plain")
	public String process() {
		sk.erni.rap.jpa.model.Process process = new Process();

		processDao.save(process);
		processDao.addProcessAttributeWithCheck(process, new ProcessAttribute("Test", "123", 1));
		processDao.addProcessAttributeWithCheck(process, new ProcessAttribute("Test", "456", 2));

		return "OK";
	}

}