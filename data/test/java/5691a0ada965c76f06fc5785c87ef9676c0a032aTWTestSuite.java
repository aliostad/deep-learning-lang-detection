package com.thoughtweb.selenium.runner;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import com.thoughtweb.selenium.administration.KDManagementProcess;
import com.thoughtweb.selenium.process.ConceptProcess;
import com.thoughtweb.selenium.process.ConnectionProcess;
import com.thoughtweb.selenium.process.HybridProcess;
import com.thoughtweb.selenium.process.NavigationProcess;
import com.thoughtweb.selenium.process.ObjectProcess;
import com.thoughtweb.selenium.process.SipraIValueProcess;
import com.thoughtweb.selenium.process.UserProcess;


@RunWith(Suite.class)
@SuiteClasses({
	NavigationProcess.class,
	ConceptProcess.class,
	ConnectionProcess.class,
	ObjectProcess.class,
	HybridProcess.class,
	SipraIValueProcess.class,
	UserProcess.class,
	KDManagementProcess.class
})
public class TWTestSuite {

}
