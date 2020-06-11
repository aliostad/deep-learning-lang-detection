package com.wineaccess.orchestration.workflow.process.cache.impl;

import java.util.HashMap;
import java.util.Map;

import org.apache.xmlbeans.XmlException;

import com.wineaccess.orchestration.workflow.process.ProcessInstance;
import com.wineaccess.orchestration.workflow.process.cache.ProcessCacheManager;

/**
 * @see ProcessCacheManager
 * @author jyoti.yadav@globallogic.com
 */
public class MemoryProcessCacheManager implements ProcessCacheManager{
	
	private Map<ProcessCacheKey, ProcessInstance> processCache = new HashMap<ProcessCacheKey, ProcessInstance>();
	
	/**
	 * @see ProcessCacheManager#getProcess(String, String)
	 */
	@Override
	public com.wineaccess.orchestration.workflow.process.ProcessInstance getProcess(String processName, String versionId) {
		
		try {
			ProcessCacheKey processCacheKey = new ProcessCacheKey(processName, versionId);
			
			if (!processCache.containsKey(processCacheKey)) {
				ProcessInstance process = new ProcessInstance(processName, versionId);
				processCache.put(processCacheKey, process);
			} 
			return processCache.get(processCacheKey);
		} catch(XmlException xmlException) {
			throw new RuntimeException("Error in getting data from cache");
		}
	}
	
	public class ProcessCacheKey {
		private String processName;
		private String version;
		
		public ProcessCacheKey(String processName, String version) {
			this.processName = processName;
			this.version = version;
		}

		public String getProcessName() {
			return processName;
		}

		public String getVersion() {
			return version;
		}
		
		public int hashCode() {
			return this.processName.concat(this.version).length();
		}
		
		public boolean equals( Object obj ) {
			ProcessCacheKey processCacheKey = (ProcessCacheKey )obj;
			if( processCacheKey.getProcessName().equals(this.processName) && processCacheKey.getVersion().equals(this.version) ) {
				return true;
			} else {
				return false;
			}
		}
	}
}

