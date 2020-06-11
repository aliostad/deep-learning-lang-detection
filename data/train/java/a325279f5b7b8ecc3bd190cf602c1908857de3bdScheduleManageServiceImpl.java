package com.bbm.gps.adm.schedule.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import com.bbm.gps.adm.schedule.service.ScheduleManageService;
import com.bbm.gps.adm.schedule.service.ScheduleManageVO;

/** 
 * 일정관리에 대한 서비스 구현클래스를 정의한다
 * <p><b>NOTE:</b> 서비스에 선언 되어있는 메소드들의 구현 클래스로 데이터 접근 클래스의 메소드를 호출한다
 * 메소드들 중에는 parameter를 넘기는 메소드도 있고 넘기지 않는 메소드도 존재한다
 * @author 범정부통계포털 이진우 
 * @since 2011.08.03 
 * @version 1.0 
 * @see 
 * 
 * <pre> 
 *  == Modification Information) == 
 *   
 *     date         author                note 
 *  -----------    --------    --------------------------- 
 *   2011.08.03     이진우      최초 생성 
 * 
 * </pre> 
 */
@Service("scheduleManageService")
public class ScheduleManageServiceImpl extends AbstractServiceImpl implements ScheduleManageService {

	/** scheduleManageDAO 서비스 호출 */ 
	@Resource(name="scheduleManageDAO")
    private ScheduleManageDAO scheduleManageDAO;
	
	/**
     * scheduleManageVO 일정목록 조회  
     * @param scheduleManageVO
     * @return List
     * @throws Exception
     * @see SC_TY,SC_TY_NM,SC_SN, SUBJECT,ORG_NM, SCHEDULE_CN,START_DT,END_DT,PLACE,STAT_ID,STAT_NM,PHON_CN,FAX_PHON_CN,
     * @see UPDT_DT, REGIST_DT
     * @see TABLE NAME : TN_SCHEDULE
     */
	@SuppressWarnings("unchecked")
	public List selectScheduleList(ScheduleManageVO scheduleManageVO) throws Exception {
		return scheduleManageDAO.selectScheduleList(scheduleManageVO);
	}
	
	/**
     * scheduleManageVO 일정목록 총 갯수를 조회한다.
     * @param scheduleManageVO
     * @return int
     * @throws Exception
     * @see totcnt 
     * @see TABLE NAME : TN_SCHEDULE
     */
	public int selectScheduleListTotCnt(ScheduleManageVO scheduleManageVO) throws Exception {
        return scheduleManageDAO.selectScheduleListTotCnt(scheduleManageVO);
	}
	
	/**
	 * scheduleManageVO 선택된 일정 상세조회  
	 * @param scheduleManageVO
	 * @return ScheduleManageVO
	 * @throws Exception
	 * @see SC_TY,SC_TY_NM,SC_SN, SUBJECT,ORG_NM, SCHEDULE_CN,START_DT,END_DT,PLACE,STAT_ID,STAT_NM,PHON_CN,FAX_PHON_CN,
     * @see UPDT_DT, REGIST_DT
	 * @see TABLE NAME : TN_SCHEDULE
	 */ 
	public ScheduleManageVO selectSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
    	return (ScheduleManageVO)scheduleManageDAO.selectSchedule(scheduleManageVO);
	}
	
	
	/**
	 * scheduleManageVO 선택된 일정 삭제 
	 * @param scheduleManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public void deleteSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
		scheduleManageDAO.deleteSchedule(scheduleManageVO);
	}

	/**
	 * scheduleManageVO VO에 담겨있는 항목을 DB에 insert 
	 * @param scheduleManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public void insertSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
    	scheduleManageDAO.insertSchedule(scheduleManageVO);    	
	}

	/**
	 * scheduleManageVO 수정할 대상 일정을 업데이트 
	 * @param scheduleManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public void updateSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
    	scheduleManageDAO.updateSchedule(scheduleManageVO);    	
	}


	

	
}
