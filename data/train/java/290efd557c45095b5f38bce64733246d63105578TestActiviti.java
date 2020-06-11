package junit;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.junit.Test;

public class TestActiviti {

	/**使用代码创建工作流需要的23张表*/
	@Test
	public void createTable(){
		ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration.createStandaloneProcessEngineConfiguration();
		//连接数据库的配置
		processEngineConfiguration.setJdbcDriver("com.mysql.jdbc.Driver");
		processEngineConfiguration.setJdbcUrl("jdbc:mysql://localhost:3306/itcast0711activiti?useUnicode=true&characterEncoding=utf8");
		processEngineConfiguration.setJdbcUsername("root");
		processEngineConfiguration.setJdbcPassword("root");
		
		/**
		 	public static final String DB_SCHEMA_UPDATE_FALSE = "false";不能自动创建表，需要表存在
  			public static final String DB_SCHEMA_UPDATE_CREATE_DROP = "create-drop";先删除表再创建表
  			public static final String DB_SCHEMA_UPDATE_TRUE = "true";如果表不存在，自动创建表
		 */
		processEngineConfiguration.setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_TRUE);
		//工作流的核心对象，ProcessEnginee对象
		ProcessEngine processEngine = processEngineConfiguration.buildProcessEngine();
		System.out.println("processEngine:"+processEngine);
	}
	
	/**使用配置文件创建工作流需要的23张表*/
	@Test
	public void createTable_2(){
//		ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration.createProcessEngineConfigurationFromResource("activiti.cfg.xml");
//		//工作流的核心对象，ProcessEnginee对象
//		ProcessEngine processEngine = processEngineConfiguration.buildProcessEngine();
		
		ProcessEngine processEngine = ProcessEngineConfiguration.createProcessEngineConfigurationFromResource("activiti.cfg.xml")	//
									.buildProcessEngine();
		System.out.println("processEngine:"+processEngine);
	}
}
