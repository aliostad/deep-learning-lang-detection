package com.ozstrategy.service.flows.impl;

import com.ozstrategy.dao.flows.ProcessFileAttachDao;
import com.ozstrategy.model.flows.ProcessFileAttach;
import com.ozstrategy.service.flows.ProcessFileAttachManager;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Created by lihao on 9/28/14.
 */
@Service("processFileAttachManager")
public class ProcessFileAttachManagerImpl implements ProcessFileAttachManager {
    @Autowired
    ProcessFileAttachDao processFileAttachDao;
    
    public List<ProcessFileAttach> listProcessFileAttachs(Map<String, Object> map, Integer start, Integer limit) {
        return processFileAttachDao.listProcessFileAttachs(map,new RowBounds(start,limit));
    }

    public Integer listProcessFileAttachsCount(Map<String, Object> map) {
        return processFileAttachDao.listProcessFileAttachsCount(map);
    }

    public ProcessFileAttach getProcessFileAttachById(Long id) {
        return processFileAttachDao.getProcessFileAttachById(id);
    }

    public void updateProcessFileAttach(ProcessFileAttach attach) {
        processFileAttachDao.updateProcessFileAttach(attach);
    }

    public void deleteProcessFileAttach(Long id) {
        processFileAttachDao.deleteProcessFileAttach(id);
    }

    public void saveProcessFileAttach(ProcessFileAttach attach) {
        processFileAttachDao.saveProcessFileAttach(attach);
    }

    public List<ProcessFileAttach> getProcessFileAttachByInstanceId(Long instanceId) {
        return processFileAttachDao.getProcessFileAttachByInstanceId(instanceId);
    }
}
