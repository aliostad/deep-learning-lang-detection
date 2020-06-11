package sk.erni.rap.jpa.test;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import sk.erni.rap.jpa.dao.ProcessDao;
import sk.erni.rap.jpa.dao.UserDao;
import sk.erni.rap.jpa.model.Process;
import sk.erni.rap.jpa.model.ProcessAttribute;
import sk.erni.rap.jpa.model.User;
import sk.erni.rap.jpa.util.ContextUtils;

import javax.ejb.EJBException;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.transaction.NotSupportedException;
import javax.transaction.SystemException;
import java.util.List;

/**
 * @author rap
 */
public class TransactionAttributeTest {

	private ProcessDao processDao;

	private UserDao userDao;

	@Before
	public void init() throws NamingException {
		Context context = ContextUtils.createContext();
		processDao = ContextUtils.lookupProcessDao(context);
		userDao = ContextUtils.lookupUserDao(context);
	}

	@Test
	public void saveProcess() throws SystemException, NotSupportedException {
		Process process = new Process();
		process.setValue("Calibrate Fuse");

		processDao.save(process);

		Process savedProcess = processDao.findById(process.getId());

		Assert.assertNotNull(savedProcess);
		Assert.assertNotNull(savedProcess.getId());
		Assert.assertEquals(process.getId(), savedProcess.getId());
	}

	@Test
	public void addProcessAttributeWithCheck() {
		Process process = new Process();
		process.setValue("Calibrate Fuse");

		processDao.save(process);

		ProcessAttribute processAttribute1 = new ProcessAttribute("Fuse depth", "14", 1);
		ProcessAttribute processAttribute2 = new ProcessAttribute("Fuse height", "5", 1);
		ProcessAttribute processAttribute3 = new ProcessAttribute("Fuse width", "3", 1);

		Integer processId = process.getId();

		processDao.addProcessAttributeWithCheck(process, processAttribute1);
		processDao.addProcessAttributeWithCheck(process, processAttribute2);
		processDao.addProcessAttributeWithCheck(process, processAttribute3);

		Process savedProcess = processDao.findById(processId);

		Assert.assertEquals(3, savedProcess.getProcessAttributes().size());
	}

	@Test(expected = EJBException.class)
	public void addProcessAttributeWithoutCheck() {
		Process process = new Process();
		process.setValue("Calibrate Fuse");

		processDao.save(process);

		ProcessAttribute processAttribute1 = new ProcessAttribute("Fuse depth", "14", 1);
		ProcessAttribute processAttribute2 = new ProcessAttribute("Fuse height", "5", 1);

		processDao.addProcessAttributeWithoutCheck(process, processAttribute1);
		processDao.addProcessAttributeWithoutCheck(process, processAttribute2);

	}

	@Test
	public void testMapKey() {
		User user = new User("Test", "test", "test");

		Process process = new Process();
		process.setValue("Calibrate Fuse");
		process.setUser(user);

		processDao.save(process);

		List<User> userList = userDao.findByFirstName("Test");

		Assert.assertEquals(1, userList.get(0).getProcesses().size());
	}

}
