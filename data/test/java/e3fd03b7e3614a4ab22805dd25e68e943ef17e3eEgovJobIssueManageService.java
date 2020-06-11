package egovframework.bopr.ikm.service;

import java.util.List;

/**
 * JobIssue관리에 관한 서비스 인터페이스 클래스
 * @jobIssue 배치운영환경 김지완
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

public interface EgovJobIssueManageService {
	
    /**
	 * 모든 JobIssue를 조회
	 * @param jobIssueManageVO JobIssueManageVO
	 * @return List<JobIssueManageVO>
	 * @exception Exception
	 */
	public List<JobIssueManageVO> selectJobIssueList(JobIssueManageVO jobIssueManageVO) throws Exception;
	
	/**
	 * JobIssue 등록
	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
	public void insertJobIssue(JobIssueManage jobIssueManage) throws Exception;
	
	/**
	 * JobIssue 수정
 	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
	public void updateJobIssue(JobIssueManage jobIssueManage) throws Exception;
	
	/**
	 * 이슈 상태만 수정
 	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
	public void updateIssueSttus(JobIssueManage jobIssueManage) throws Exception;
	
	/**
	 * JobIssue 삭제
	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
	public void deleteJobIssue(JobIssueManage jobIssueManage) throws Exception;

	/**
	 * 목록조회 카운트를 반환한다
	 * @param jobIssueManageVO JobIssueManageVO
	 * @return int
	 * @exception Exception
	 */
	public int selectJobIssueListTotCnt(JobIssueManageVO jobIssueManageVO) throws Exception;	
	
	/**
	 * 개별 JobIssue 조회
	 * @param jobIssueManageVO JobIssueManageVO
	 * @return JobIssueManageVO
	 * @exception Exception
	 */
	public JobIssueManageVO selectJobIssue(JobIssueManageVO jobIssueManageVO) throws Exception;
	
	/**
	 * 해당 이슈에 대한 답글을 조회
	 * @param issueAnwserVO IssueAnwserVO
	 * @return List<IssueAnwserVO>
	 * @exception Exception
	 */
	public List<IssueAnwserVO> selectIssueAnswerList(IssueAnwserVO issueAnwserVO) throws Exception;
	
	/**
	 * 해당 이슈에 대한 답글을 입력
	 * @param issueAnwserVO IssueAnwserVO
	 * @exception Exception
	 */
	public void insertIssueAnswer(IssueAnwserVO issueAnwserVO) throws Exception;
	
	/**
	 * 해당 이슈에 대한 답글을 수정
	 * @param issueAnwserVO IssueAnwserVO
	 * @exception Exception
	 */
	public void updateIssueAnswer(IssueAnwserVO issueAnwserVO) throws Exception;
	
	/**
	 * 해당 이슈에 대한 답글을 삭제
	 * @param issueAnwserVO IssueAnwserVO
	 * @exception Exception
	 */
	public void deleteIssueAnswer(IssueAnwserVO issueAnwserVO) throws Exception;
//  여기서부터는 개발 중단
//	/**
//	 * 개별사용자에게 할당된 권한리스트 조회
//	 * @param jobIssueManageVO JobIssueManageVO
//	 * @return List<JobIssueManageVO>
//	 * @exception Exception
//	 */
//	public List<JobIssueManageVO> selectJobIssueList(JobIssueManageVO jobIssueManageVO) throws Exception;

}
