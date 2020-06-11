package com.ppcredit.bamboo.backend.web.rest.admin.process.service.impl;

import com.ppcredit.bamboo.backend.web.rest.admin.process.dao.ProcessDAO;
import com.ppcredit.bamboo.backend.web.rest.admin.process.dto.ProcessDTO;
import com.ppcredit.bamboo.backend.web.rest.admin.process.dto.ProcessJoinDTO;
import com.ppcredit.bamboo.backend.web.rest.admin.process.service.ProcessService;
import com.ppcredit.bamboo.backend.web.rest.admin.util.Pager;
import com.ppcredit.bamboo.backend.web.rest.admin.util.UUID;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

@Service("myProcessService")
public class ProcessServiceImpl implements ProcessService {

    private static Logger logger = LoggerFactory.getLogger(ProcessServiceImpl.class); // 日志

    @Inject
    private ProcessDAO myProcessDAO;

    @Override
    public ProcessDTO save(String appKey, String processName, String processDesc)  {

        logger.info("流程保存。。。");
        ProcessDTO process = new ProcessDTO();

        process.setAppKey(appKey);
        process.setProcessId(UUID.randomUUID().toString().replace("-", ""));
        process.setProcessName(processName);
        process.setProcessDesc(processDesc);

        myProcessDAO.save(process);
        return process;
    }

    @Override
    public Pager query(String param, int offset, int pagesize) {
        return myProcessDAO.query(param, offset, pagesize);
    }

    @Override
    public void delProcessByProcessId(String processId) {
        myProcessDAO.delProcessByProcessId
                (processId);
    }

    @Override
    public ProcessDTO update(int id, String processName, String processDesc) {
        return myProcessDAO.update
                (id, processName, processDesc);
    }

	@Override
	public List<ProcessDTO> queryProcessList() {
		return myProcessDAO.queryProcessList();
	}

	@Override
	public List<ProcessDTO> queryCheckedProcessList(String appkey) {
		return myProcessDAO.queryCheckedProcessList(appkey);
	}

	@Override
	public void saveProcessAppkey(String appKey, String ids)  {
		try {
			myProcessDAO.deleleAppKey(appKey);
			ProcessJoinDTO process = null;
			if (StringUtils.isNotEmpty(ids)){
				String[] idArray = ids.split(",");
				for(int i = 0 ;i<idArray.length;i++){
					process = new ProcessJoinDTO();
					process.setAppKey(appKey);
					process.setProcessId(idArray[i]);
					myProcessDAO.saveProcessAppkey(process);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

    @Override
    public Pager queryByName(String param, int i, int pageSize) {
        return myProcessDAO.queryByName(param, i, pageSize);
    }

}
