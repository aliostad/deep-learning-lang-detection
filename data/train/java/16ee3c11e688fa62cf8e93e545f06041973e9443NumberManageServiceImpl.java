package cn.voicet.gc.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.voicet.gc.dao.NumberManageDao;
import cn.voicet.gc.service.NumberManageService;
import cn.voicet.gc.util.DotSession;

@Transactional(readOnly=true)
@Service(NumberManageService.SERVICE_NAME)
public class NumberManageServiceImpl implements NumberManageService{
	
	@Resource(name=NumberManageDao.SERVICE_NAME)
	private NumberManageDao numberManageDao;

	public void getNumberManageInfo(DotSession ds) {
		numberManageDao.getNumberManageInfo(ds);
	}

}
