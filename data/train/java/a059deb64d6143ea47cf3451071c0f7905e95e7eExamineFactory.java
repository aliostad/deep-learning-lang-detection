package factory;

import tool.vopo.VOPOFactory;
import bl.blImpl.examinebl.ExamineBLManageImpl;
import bl.blService.examineblService.ExamineblManageService;

/** 
 * Client//factory//ExamineFactory.java
 * @author CXWorks
 * @date 2015年12月3日 下午7:18:09
 * @version 1.0 
 */
public class ExamineFactory extends BLFactory {
	private static ExamineblManageService examineblManageService;
	public static ExamineblManageService getExamineblManageService(){
		if (examineblManageService==null) {
			examineblManageService=new ExamineBLManageImpl(vopoFactory);
		}
		return examineblManageService;
	}
	
}
