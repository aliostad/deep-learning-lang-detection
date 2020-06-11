package jeesite.dao;

import javax.annotation.Resource;

import org.junit.Test;

import com.thinkgem.jeesite.common.persistence.Parameter;
import com.thinkgem.jeesite.modules.process.dao.ProcessDao;
import com.thinkgem.jeesite.modules.process.entity.Process;
import com.thinkgem.jeesite.modules.process.service.ProcessService;

import jeesite.BaseTestCase;

public class ProcessDaoTest extends BaseTestCase{

	@Resource
	private ProcessDao processDao;
	
	@Resource
	private ProcessService processService;
	
	@Test
	public void processQueryTest(){
		Process process = processDao.getByHql("from Process process where process.processIventory.id=:p1 and state=:p2", new Parameter("93e56a1b8f074b1bbb98cea751bb56a0",Process.STATE_PROCESSING));
		System.out.println(process.getId());
	}
	
	@Test
	public void deleteTest(){
		processService.deleteProcess("93e56a1b8f074b1bbb98cea751bb56a0", new String[]{"1ae982a5600d4ad5a8652060d977c8f0","874508aef38c4bfc8b2a018ce0eefc21"});
	}
}
