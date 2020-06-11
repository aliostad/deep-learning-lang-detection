package egovframework.bopr.ikm.service;

import java.util.List;

/**
 * Job지식관리에 대한 Vo 클래스
 * @author 배치운영환경 김지완
 * @since 2012.07.16
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2012.07.16  김지완          최초 생성
 *
 * </pre>
 */

public class JobKnwldgManageVO extends JobKnwldgManage {

	private static final long serialVersionUID = 1L;

	List <JobKnwldgManageVO> jobKnwldgManageList;

	/**
	 * JobKnwldgManage 를 리턴한다.
	 * @return JobKnwldgManage
	 */
	public JobKnwldgManage getJobKnwldgManage()
    {
    	return getJobKnwldgManage();
    }
	/**
	 * JobKnwldgManage 값을 설정한다.
	 * @param jobKnwldgManage JobKnwldgManage
	 */	
    public void setJobKnwldgManage(JobKnwldgManage jobKnwldgManage)
    {
    	setJobKnwldgManage(jobKnwldgManage);
    }

	/**
	 * jobKnwldgManageList attribute 를 리턴한다.
	 * @return List<JobKnwldgManageVO>
	 */
	public List<JobKnwldgManageVO> getJobKnwldgManageList() {
		return jobKnwldgManageList;
	}

	/**
	 * jobKnwldgManageList attribute 값을 설정한다.
	 * @param jobKnwldgManageList List<JobKnwldgManageVO> 
	 */
	public void setJobKnwldgManageList(List<JobKnwldgManageVO> jobKnwldgManageList) {
		this.jobKnwldgManageList = jobKnwldgManageList;
	}



}