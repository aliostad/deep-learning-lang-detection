package egovframework.bopr.ikm.service.impl;

import java.util.List;

import egovframework.bopr.ikm.service.EgovJobKnwldgManageService;
import egovframework.bopr.ikm.service.JobKnwldgManage;
import egovframework.bopr.ikm.service.JobKnwldgManageVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**
 * Job지식관리에 관한 ServiceImpl 클래스
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

@Service("egovJobKnwldgManageService")
public class EgovJobKnwldgManageServiceImpl extends EgovAbstractServiceImpl implements EgovJobKnwldgManageService {
    
	@Resource(name="jobKnwldgManageDAO")
    private JobKnwldgManageDAO jobKnwldgManageDAO;
	    
    /**
	 *JobKnwldg 목록 조회
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @return List<JobKnwldgManageVO>
	 * @exception Exception
	 */
    public List<JobKnwldgManageVO> selectJobKnwldgList(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
        return jobKnwldgManageDAO.selectJobKnwldgList(jobKnwldgManageVO);
    }
    
	/**
	 * JobKnwldg 등록
	 * @param jobKnwldgManage JobKnwldgManage
	 * @exception Exception
	 */
    public void insertJobKnwldg(JobKnwldgManage jobKnwldgManage) throws Exception {
    	jobKnwldgManageDAO.insertJobKnwldg(jobKnwldgManage);
    }

    /**
	 * JobKnwldg 수정
	 * @param jobKnwldgManage JobKnwldgManage
	 * @exception Exception
	 */
    public void updateJobKnwldg(JobKnwldgManage jobKnwldgManage) throws Exception {
    	jobKnwldgManageDAO.updateJobKnwldg(jobKnwldgManage);
    }

    /**
	 * JobKnwldg 삭제
	 * @param jobKnwldgManage JobKnwldgManage
	 * @exception Exception
	 */
    public void deleteJobKnwldg(JobKnwldgManage jobKnwldgManage) throws Exception {
    	jobKnwldgManageDAO.deleteJobKnwldg(jobKnwldgManage);
    	
    }

    /**
	 * JobKnwldg 조회
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectJobKnwldgListTotCnt(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
        return jobKnwldgManageDAO.selectJobKnwldgListTotCnt(jobKnwldgManageVO);
    }

    /**
	 * JobKnwldg 조회
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @return JobKnwldgManageVO
	 * @exception Exception
	 */
    public JobKnwldgManageVO selectJobKnwldg(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
    	JobKnwldgManageVO resultVO = jobKnwldgManageDAO.selectJobKnwldg(jobKnwldgManageVO);
        if (resultVO == null){
        	throw processException("info.nodata.msg");
        }
            
        return resultVO;
    }
    
    /**
	 * 조회수 증가
	 * @param jobKnwldgManageVO JobKnwldgManageVO
	 * @exception Exception
	 */
	public void addReadCount(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
		jobKnwldgManageDAO.addReadCount(jobKnwldgManageVO);
	}
//    
//    /**
//	 * 모든 권한목록을 조회한다.
//	 * @param jobKnwldgManageVO JobKnwldgManageVO
//	 * @return List<JobKnwldgManageVO>
//	 * @exception Exception
//	 */
//	public List<JobKnwldgManageVO> selectJobKnwldgAllList(JobKnwldgManageVO jobKnwldgManageVO) throws Exception {
//    	return jobKnwldgManageDAO.selectJobKnwldgAllList(jobKnwldgManageVO);
//    }

	
}
