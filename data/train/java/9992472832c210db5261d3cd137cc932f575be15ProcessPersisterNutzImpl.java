package org.fireflow.engine.modules.persistence.nutz;

import java.io.ByteArrayInputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.fireflow.engine.context.RuntimeContext;
import org.fireflow.engine.entity.repository.ProcessDescriptor;
import org.fireflow.engine.entity.repository.ProcessDescriptorProperty;
import org.fireflow.engine.entity.repository.ProcessKey;
import org.fireflow.engine.entity.repository.ProcessRepository;
import org.fireflow.engine.entity.repository.impl.ProcessDescriptorImpl;
import org.fireflow.engine.entity.repository.impl.ProcessRepositoryImpl;
import org.fireflow.engine.modules.persistence.ProcessPersister;
import org.fireflow.engine.modules.processlanguage.ProcessLanguageManager;
import org.fireflow.model.InvalidModelException;
import org.firesoa.common.util.Utils;
import org.nutz.dao.Cnd;
import org.nutz.dao.Sqls;
import org.nutz.dao.sql.Sql;

public class ProcessPersisterNutzImpl extends AbsPersisterNutzImpl implements
		ProcessPersister {
	private static final Log log = LogFactory.getLog(ProcessPersisterNutzImpl.class);
		
	//TODO 下面这个Cache是否需要，待研究……
	// process相关的信息实际上已经缓存在KernelManager中了，应该无需保留，此cache机制待删除掉，2013-04-24
	Map<ProcessKey,ProcessRepository> cache = new HashMap<ProcessKey,ProcessRepository>();
	private boolean useProcessCache = false;
	
	public boolean isUseProcessCache(){
		return useProcessCache;
	}
	
	public void setUseProcessCache(boolean b){
		this.useProcessCache = b;
	}
	
	public void deleteAllProcesses() {
		dao().clear(ProcessDescriptorImpl.class);

	}

	public ProcessRepository persistProcessToRepository(String processXml,
			ProcessDescriptor descriptor) {
		ProcessRepositoryImpl repository = (ProcessRepositoryImpl)descriptor.toProcessRepository();
		repository.setProcessContent(processXml);
		
		//表示插入操作，需要重新生成version字段
		if (repository.getVersion()==null || repository.getVersion()<=0){
			int v = this.findTheLatestVersion(repository.getProcessId(), repository.getProcessType());
			repository.setVersion(v+1);
		}
		
		this.saveOrUpdate(repository);
		//缓存
		if (useProcessCache){
			this.cache(repository);
		}
		return repository;
	}

	public ProcessRepository findProcessRepositoryByProcessKey(
			ProcessKey processKey) throws InvalidModelException {
		Cnd cnd = Cnd
				.where(ProcessDescriptorProperty.PROCESS_ID.getPropertyName(),
						"=", processKey.getProcessId())
				.and(ProcessDescriptorProperty.PROCESS_TYPE.getPropertyName(),
						"=", processKey.getProcessType())
				.and(ProcessDescriptorProperty.VERSION.getPropertyName(), "=",
						processKey.getVersion());

		ProcessRepository repository = this.getFromCache(processKey);
		if (repository != null) {
			return repository;
		}
		repository = dao()
				.fetch(ProcessRepositoryImpl.class, cnd);
		if (repository != null) {
			try{
				RuntimeContext ctx = this.getPersistenceService().getRuntimeContext();				
				ProcessLanguageManager processUtil = ctx.getEngineModule(ProcessLanguageManager.class, processKey.getProcessType());
				String xml = repository.getProcessContent();
				String encoding = Utils.findXmlCharset(xml);
				ByteArrayInputStream inStream = new ByteArrayInputStream(xml.getBytes(encoding));
				Object obj = processUtil.deserializeXml2Process(inStream);
				((ProcessRepositoryImpl)repository).setProcessObject(obj);
				//TODO 
				// repository.getFileName() 与 WorkflowProcess.getClasspathUri()的设置关系如何处理？
				
			}catch(UnsupportedEncodingException e){
				log.error(e);
			}

		}		
		return (ProcessRepository) repository;
	}

	public ProcessRepository findTheLatestVersionOfProcessRepository(
			String processId, String processType) throws InvalidModelException {
		int v = this.findTheLatestVersion(processId,processType) ;
		if (v==0){
			return null;
		}else{
			ProcessKey processKey = new ProcessKey(processId,v,processType);
			ProcessRepository repository = this.getFromCache(processKey);
			if (repository!=null) {
				return repository;
			}else{
				return this.findProcessRepositoryByProcessKey(new ProcessKey(processId,v,processType));
			}
		}
	}

	public String findProcessXml(ProcessKey processKey) {
		ProcessRepository repository;
		try {
			repository = this.findProcessRepositoryByProcessKey(processKey);
			if (repository==null)return "";
			return repository.getProcessContent();
		} catch (InvalidModelException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}

	public ProcessDescriptor findProcessDescriptorByProcessKey(
			ProcessKey processKey) {
		Cnd cnd = Cnd.where(ProcessDescriptorProperty.PROCESS_ID.getPropertyName(), "=", processKey.getProcessId())
					.and(ProcessDescriptorProperty.PROCESS_TYPE.getPropertyName(),"=",processKey.getProcessType())
					.and(ProcessDescriptorProperty.VERSION.getPropertyName(),"=",processKey.getVersion());
		
		ProcessRepository repository = this.getFromCache(processKey);
		if (repository!=null) {
			return repository;
		}
		ProcessDescriptor result = dao().fetch(ProcessDescriptorImpl.class, cnd);
		return (ProcessDescriptor)result;
	}

	public ProcessDescriptor findTheLatestVersionOfProcessDescriptor(
			String processId, String processType) {
		int v = this.findTheLatestVersion(processId,processType) ;
		if (v==0){
			return null;
		}else{
			ProcessKey processKey = new ProcessKey(processId,v,processType);
			ProcessRepository repository = this.getFromCache(processKey);
			if (repository!=null) {
				return repository;
			}else{
				return this.findProcessDescriptorByProcessKey(new ProcessKey(processId,v,processType));
			}
		}
	}

	public int findTheLatestVersion(String processId, String processType) {
		Sql sql = Sqls.create("SELECT max(VERSION) FROM T_FF_DF_PROCESS_REPOSITORY WHERE PROCESS_ID=@processId and PROCESS_TYPE=@processType");
		sql.params().set("processId", processId);
		sql.params().set("processType", processType);
		
		sql.setCallback(Sqls.callback.integer());
		dao().execute(sql);
		try{
			int result = sql.getInt();
			return result;
		}catch(NullPointerException e){
			return 0;
		}
	}

	public int findTheLatestPublishedVersion(String processId,
			String processType) {
		Sql sql = Sqls.create("SELECT max(VERSION) FROM T_FF_DF_PROCESS_REPOSITORY WHERE PROCESS_ID=@processId and PROCESS_TYPE=@processType and PUBLISH_STATE=@publishState");
		sql.params().set("processId", processId);
		sql.params().set("processType", processType);
		sql.params().set("publishState",  Boolean.TRUE);
		
		sql.setCallback(Sqls.callback.integer());
		dao().execute(sql);
		try{
			int result = sql.getInt();
			return result;
		}catch(NullPointerException e){
			return 0;
		}
		
	}


	@SuppressWarnings("unchecked")
	public Class getEntityClass4Runtime(Class interfaceClz){
		if (interfaceClz.isAssignableFrom(ProcessDescriptor.class)){
			return ProcessDescriptorImpl.class;
		}else if (interfaceClz.isAssignableFrom(ProcessRepository.class)){
			return ProcessRepositoryImpl.class;
		}
		return null;		
	}
	
	protected ProcessRepository getFromCache(ProcessKey key){
		if (this.isUseProcessCache()){
			return this.cache.get(key);
		}
		return null;
	}

	protected void cache(ProcessRepository processRepository){
		if (this.isUseProcessCache()) {
			ProcessKey pk = new ProcessKey(processRepository.getProcessId(),
					processRepository.getVersion(), processRepository
							.getProcessType());
			this.cache.put(pk, processRepository);
		}
	}
}
