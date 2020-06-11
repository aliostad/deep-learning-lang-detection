package egovframework.bopr.ikm.service;

import java.util.List;

/**
 * JobIssue관리에 대한 Vo 클래스
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

public class JobIssueManageVO extends JobIssueManage {

	private static final long serialVersionUID = 1L;

	List <JobIssueManageVO> jobIssueManageList;

	/**
	 * JobIssueManage 를 리턴한다.
	 * @return JobIssueManage
	 */
	public JobIssueManage getJobIssueManage()
    {
    	return getJobIssueManage();
    }
	/**
	 * JobIssueManage 값을 설정한다.
	 * @param jobIssueManage JobIssueManage
	 */	
    public void setJobIssueManage(JobIssueManage jobIssueManage)
    {
    	setJobIssueManage(jobIssueManage);
    }

	/**
	 * jobIssueManageList attribute 를 리턴한다.
	 * @return List<JobIssueManageVO>
	 */
	public List<JobIssueManageVO> getJobIssueManageList() {
		return jobIssueManageList;
	}

	/**
	 * jobIssueManageList attribute 값을 설정한다.
	 * @param jobIssueManageList List<JobIssueManageVO> 
	 */
	public void setJobIssueManageList(List<JobIssueManageVO> jobIssueManageList) {
		this.jobIssueManageList = jobIssueManageList;
	}



}