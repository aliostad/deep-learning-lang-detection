package tests.business;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestName;

import business.ProcessUser;
import static org.junit.Assert.*;

public class ProcessUserTest 
{
	@Rule
	public TestName testName = new TestName();
	
	@Before
	public void before()
	{
		System.out.println("Running test: " + this.getClass().toString() + "::" + testName.getMethodName());
	}
	
	@After
	public void after()
	{
		System.out.println("Finished test.\n");
	}
	
	@Test
	public void testInsert()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("User was inserted", process.insert(null));
	}
	
	@Test
	public void testDelete()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("User was deleted", process.delete(null));
	}
	
	@Test
	public void testUpdate()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("User was updated", process.update(null));
	}
	
	@Test
	public void testValidate()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("Username/ password invalid", process.validateUser(null, null));
	}
	
	@Test
	public void testValidate2()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("Username/ password invalid", process.validateUser("", null));
	}
	
	@Test
	public void testValidate3()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("Username/ password invalid", process.validateUser(null, ""));
	}
	
	@Test
	public void testValidate4()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("Password invalid", process.validateUser("user", null));
	}
	
	@Test
	public void testValidate5()
	{
		ProcessUser process = new ProcessUser();
		assertFalse("Username invalid", process.validateUser(null, "pass"));
	}
}
