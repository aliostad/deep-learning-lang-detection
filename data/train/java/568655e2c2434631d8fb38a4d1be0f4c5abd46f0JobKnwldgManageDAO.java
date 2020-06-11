package egovframework.bopr.ikm.service.impl;

import java.util.List;

import egovframework.bopr.ikm.service.JobKnwldgManage;
import egovframework.bopr.ikm.service.JobKnwldgManageVO;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

import org.springframework.stereotype.Repository;

/**
 * Job지식관리에 대한 DAO 클래스
 * @jobKnwldg 배치운영환경 김지완
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

@Repository("jobKnwldgManageDAO")
public class JobKnwldgManageDAO extends EgovAbstractDAO {

	 /**
	 * 모든 JobKnwldg 조회
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @return List<JobKnwldgManageVO>
	 * @exception Exception
	 */
    @SuppressWarnings("unchecked")
	public List<JobKnwldgManageVO> selectJobKnwldgList(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
        return (List<JobKnwldgManageVO>) list("jobKnwldgManageDAO.selectJobKnwldgList", jobKnwldgManageVO);
    }

	/**
	 * JobKnwldg 등록
	 * @param jobKnwldgManage JobKnwldgManage
	 * @exception Exception
	 */
    public void insertJobKnwldg(JobKnwldgManage jobKnwldgManage) throws Exception {
        insert("jobKnwldgManageDAO.insertJobKnwldg", jobKnwldgManage);
    }

    /**
	 * JobKnwldg 수정
	 * @param jobKnwldgManage JobKnwldgManage
	 * @exception Exception
	 */
    public void updateJobKnwldg(JobKnwldgManage jobKnwldgManage) throws Exception {
        update("jobKnwldgManageDAO.updateJobKnwldg", jobKnwldgManage);
    }

    /**
	 * JobKnwldg 삭제
	 * @param jobKnwldgManage JobKnwldgManage
	 * @exception Exception
	 */
    public void deleteJobKnwldg(JobKnwldgManage jobKnwldgManage) throws Exception {
        delete("jobKnwldgManageDAO.deleteJobKnwldg", jobKnwldgManage);
    }

    /**
	 * JobKnwldg 총 갯수 조회
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectJobKnwldgListTotCnt(JobKnwldgManageVO jobKnwldgManageVO)  throws Exception {
        return (Integer)select("jobKnwldgManageDAO.selectJobKnwldgListTotCnt", jobKnwldgManageVO);
    }

    /**
	 * JobKnwldg 조회
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @return JobKnwldgManageVO
	 * @exception Exception
	 */
    public JobKnwldgManageVO selectJobKnwldg(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
        return (JobKnwldgManageVO) select("jobKnwldgManageDAO.selectJobKnwldg", jobKnwldgManageVO);
    }

    /**
	 * 조회수 증가
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @exception Exception
	 */
    public void addReadCount(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
    	update("jobKnwldgManageDAO.addReadCount", jobKnwldgManageVO);
    }

//
//    /**
//	 * 사용자목록을 조회한다.
//	 * @param jobKnwldgManageVO  JobKnwldgManageVO
//	 * @return List<JobKnwldgManageVO>
//	 * @exception Exception
//	 */
//    @SuppressWarnings("unchecked")
//	public List<JobKnwldgManageVO> selectJobKnwldgList(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
//        return list("jobKnwldgManageDAO.selectJobKnwldgList", jobKnwldgManageVO);
//    }
}
