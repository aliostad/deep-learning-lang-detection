//package dwx.tech.res.activiti.util;
//
//import org.activiti.engine.ProcessEngine;
//import org.activiti.engine.ProcessEngineConfiguration;
//
//public class ActivitiUtils {
//	private static ProcessEngine processEngine;
//
//	/**
//	 * 单例模式获取引擎对象
//	 */
//	public static ProcessEngine getProcessEngine() {
//		if (processEngine == null) {
//			/*
//			 * 使用默认的配置文件名称（activiti.cfg.xml）创建引擎对象
//			 */
//			processEngine = ProcessEngineConfiguration.createProcessEngineConfigurationFromResourceDefault().buildProcessEngine();
//		}
//		return processEngine;
//	}
//
//}
