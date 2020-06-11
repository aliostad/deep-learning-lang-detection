package com.info.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.info.common.dao.IBaseDao;
import com.info.common.util.AppSEQHelper;
import com.info.domain.TProjectProcess;
import com.info.domain.TTask;
import com.info.domain.TWfProccessActive;
import com.info.domain.TWfProcess;

@Service
@Transactional
public class BussProjectProcessService {
	@Autowired
	IBaseDao<TProjectProcess> projectProcessDao;
	@Autowired
	AppSEQHelper SEQHelper;
	@Autowired
	WfProcessUtils wfUtils;
	@Autowired
	IBaseDao<TWfProccessActive> activeDao;
	@Autowired
	IBaseDao<TWfProcess> processDao;
	@Autowired
	IBaseDao<TTask> taskDao;
	/**
	 * 
	 * @Description	: 设置process历史
	 * @Author		: chunlei
	 * @Date		: 2013-04-23 17-52
	 * @param process
	 * @param typeid
	 * @param taskName
	 * @return
	 */
	public boolean  addProcess(TProjectProcess process,int typeid,String taskName){
	    int processId=wfUtils.addNewProcess(typeid);
	    wfUtils.setProcessState(processId, 5);
	    return wfUtils.setProcessTitle(processId, process.getFId(), taskName);
	}
	
	public Object getTaskPMById(Integer id) {
		String SQL = "select dbo.FN_getTaskPM(a.f_id) as TaskPM from dbo.T_Task a where a.f_id ="+id;
		javax.persistence.Query query = taskDao.CreateNativeSQL(SQL);
		return (Object)query.getSingleResult();
	}
	
	public TWfProcess getWfProcessByID(Integer processId) {
		return processDao.GetEntity(TWfProcess.class, processId);
	}
	
	public TWfProccessActive getWfProccessActiveByID(Integer activeId) {
		return activeDao.GetEntity(TWfProccessActive.class, activeId);
	}
	
	public TProjectProcess getProjectProcessForID(Integer id){
		return projectProcessDao.GetEntity(TProjectProcess.class, id);
	}
	
	public TProjectProcess update(TProjectProcess projectProcess,int processId,String title){
		if(projectProcessDao.Update(projectProcess) && wfUtils.setProcessTitle(processId, projectProcess.getFId(), title)){
			return projectProcess;
		}else{
			return null;
		}
	}
	
	public TProjectProcess post(TProjectProcess projectProcess,int activeId){
		if(projectProcessDao.Update(projectProcess) && wfUtils.activeComplet(activeId)){
			return projectProcess;
		}else{
			return null;
		}
	}
	
	public TProjectProcess save(TProjectProcess projectProcess,int processId,String title){
		Integer id = SEQHelper.getCurrentVal("SEQ_PROJECTPROCESS");
		projectProcess.setFId(id);
		if(projectProcessDao.Save(projectProcess) && wfUtils.setProcessTitle(processId, id, title)){
			return projectProcess;
		}else{
			return null;
		}
	}
	
	public boolean isCanDestroy(Integer processId){
		if(wfUtils.isCanDestroy(processId)){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean delete(Integer id, Integer activeId,Integer processId) {
		if (projectProcessDao.Delete(TProjectProcess.class, id)
				&& activeDao.Delete(TWfProccessActive.class, activeId)
				&& processDao.Delete(TWfProcess.class, processId)) {
			return true;
		} else {
			return false;
		}
	}
	
}
