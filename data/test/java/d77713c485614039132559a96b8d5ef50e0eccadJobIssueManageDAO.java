package egovframework.bopr.ikm.service.impl;

import java.util.List;

import egovframework.bopr.ikm.service.IssueAnwserVO;
import egovframework.bopr.ikm.service.JobIssueManage;
import egovframework.bopr.ikm.service.JobIssueManageVO;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

import org.springframework.stereotype.Repository;

/**
 * JobIssue관리에 대한 DAO 클래스
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

@Repository("jobIssueManageDAO")
public class JobIssueManageDAO extends EgovAbstractDAO {

	 /**
	 * 모든 JobIssue 조회
	 * @param jobIssueManageVO JobIssueManageVO
	 * @return List<JobIssueManageVO>
	 * @exception Exception
	 */
    @SuppressWarnings("unchecked")
	public List<JobIssueManageVO> selectJobIssueList(JobIssueManageVO jobIssueManageVO) throws Exception {
        return (List<JobIssueManageVO>) list("jobIssueManageDAO.selectJobIssueList", jobIssueManageVO);
    }

	/**
	 * JobIssue 등록
	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
    public void insertJobIssue(JobIssueManage jobIssueManage) throws Exception {
        insert("jobIssueManageDAO.insertJobIssue", jobIssueManage);
    }

    /**
	 * JobIssue 수정
	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
    public void updateJobIssue(JobIssueManage jobIssueManage) throws Exception {
        update("jobIssueManageDAO.updateJobIssue", jobIssueManage);
    }

    /**
	 * 이슈 상태만 수정
 	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
	public void updateIssueSttus(JobIssueManage jobIssueManage) throws Exception{
		update("jobIssueManageDAO.updateIssueSttus", jobIssueManage);
	}

    /**
	 * JobIssue 삭제
	 * @param jobIssueManage JobIssueManage
	 * @exception Exception
	 */
    public void deleteJobIssue(JobIssueManage jobIssueManage) throws Exception {
        delete("jobIssueManageDAO.deleteJobIssue", jobIssueManage);
    }

    /**
	 * JobIssue 총 갯수 조회
	 * @param jobIssueManageVO JobIssueManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectJobIssueListTotCnt(JobIssueManageVO jobIssueManageVO)  throws Exception {
        return (Integer)select("jobIssueManageDAO.selectJobIssueListTotCnt", jobIssueManageVO);
    }

    /**
	 * JobIssue 조회
	 * @param jobIssueManageVO JobIssueManageVO
	 * @return JobIssueManageVO
	 * @exception Exception
	 */
    public JobIssueManageVO selectJobIssue(JobIssueManageVO jobIssueManageVO) throws Exception {
        return (JobIssueManageVO) select("jobIssueManageDAO.selectJobIssue", jobIssueManageVO);
    }

	/**
	 * 해당 이슈에 대한 답글을 조회
	 * @param issueAnwserVO IssueAnwserVO
	 * @return List<IssueAnwserVO>
	 * @exception Exception
	 */
	public List<IssueAnwserVO> selectIssueAnswerList(IssueAnwserVO issueAnwserVO) throws Exception{
		return (List<IssueAnwserVO>) list("jobIssueManageDAO.selectIssueAnswerList", issueAnwserVO);
	}

    /**
	 * 해당 이슈에 대한 답글을 입력
	 * @param issueAnwserVO IssueAnwserVO
	 * @exception Exception
	 */
	public void insertIssueAnswer(IssueAnwserVO issueAnwserVO) throws Exception {
		insert("jobIssueManageDAO.insertIssueAnswer", issueAnwserVO);
	}

	/**
	 * 해당 이슈에 대한 답글을 삭제
	 * @param issueAnwserVO IssueAnwserVO
	 * @exception Exception
	 */
	public void deleteIssueAnswer(IssueAnwserVO issueAnwserVO) throws Exception{
		delete("jobIssueManageDAO.deleteIssueAnswer", issueAnwserVO);
	}

	/**
	 * 해당 이슈에 대한 답글을 수정
	 * @param issueAnwserVO IssueAnwserVO
	 * @exception Exception
	 */
	public void updateIssueAnswer(IssueAnwserVO issueAnwserVO) throws Exception{
		update("jobIssueManageDAO.updateIssueAnswer", issueAnwserVO);
	}

//
//    /**
//	 * 사용자목록을 조회한다.
//	 * @param jobIssueManageVO  JobIssueManageVO
//	 * @return List<JobIssueManageVO>
//	 * @exception Exception
//	 */
//    @SuppressWarnings("unchecked")
//	public List<JobIssueManageVO> selectJobIssueList(JobIssueManageVO jobIssueManageVO) throws Exception {
//        return list("jobIssueManageDAO.selectJobIssueList", jobIssueManageVO);
//    }
}
