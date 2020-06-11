package egovframework.bopr.uam.service.impl;

import java.util.List;

import egovframework.bopr.uam.service.EgovLoginPolicyManageService;
import egovframework.bopr.uam.service.LoginPolicyManage;
import egovframework.bopr.uam.service.LoginPolicyManageVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**
 * 로그인정책관리에 관한 ServiceImpl 클래스
 * @loginPolicy 배치운영환경 김지완
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

@Service("egovLoginPolicyManageService")
public class EgovLoginPolicyManageServiceImpl extends EgovAbstractServiceImpl implements EgovLoginPolicyManageService {
    
	@Resource(name="loginPolicyManageDAO")
    private LoginPolicyManageDAO loginPolicyManageDAO;

    /**
	 * 로그인정책을 받는 사용자 목록 조회
	 * @param loginPolicyManageVO LoginPolicyManageVO
	 * @return List<LoginPolicyManageVO>
	 * @exception Exception
	 */
    public List<LoginPolicyManageVO> selectLoginPolicyList(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
        return loginPolicyManageDAO.selectLoginPolicyList(loginPolicyManageVO);
    }
    
	/**
	 * 사용자에 대한 로그인 정책 등록
	 * @param loginPolicyManage LoginPolicyManage
	 * @exception Exception
	 */
    public void insertLoginPolicy(LoginPolicyManage loginPolicyManage) throws Exception {
    	loginPolicyManageDAO.insertLoginPolicy(loginPolicyManage);
    }

    /**
	 * 사용자에 대한 로그인 정책 수정
	 * @param loginPolicyManage LoginPolicyManage
	 * @exception Exception
	 */
    public void updateLoginPolicy(LoginPolicyManage loginPolicyManage) throws Exception {
    	loginPolicyManageDAO.updateLoginPolicy(loginPolicyManage);
    }

    /**
	 * 사용자에 대한 로그인 정책 삭제
	 * @param loginPolicyManage LoginPolicyManage
	 * @exception Exception
	 */
    public void deleteLoginPolicy(LoginPolicyManage loginPolicyManage) throws Exception {
    	loginPolicyManageDAO.deleteLoginPolicy(loginPolicyManage);
    }

    /**
	 * 로그인 정책 목록 카운트를 조회
	 * @param loginPolicyManageVO LoginPolicyManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectLoginPolicyListTotCnt(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
        return loginPolicyManageDAO.selectLoginPolicyListTotCnt(loginPolicyManageVO);
    }

    /**
	 * 사용자에 대한 로그인 정책 조회.
	 * @param loginPolicyManageVO LoginPolicyManageVO
	 * @return LoginPolicyManageVO
	 * @exception Exception
	 */
    public LoginPolicyManageVO selectLoginPolicy(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
    	LoginPolicyManageVO resultVO = loginPolicyManageDAO.selectLoginPolicy(loginPolicyManageVO);
        if (resultVO == null){
        	throw processException("info.nodata.msg");
        }
            
        return resultVO;
    }
//    
//    /**
//	 * 모든 권한목록을 조회한다.
//	 * @param loginPolicyManageVO LoginPolicyManageVO
//	 * @return List<LoginPolicyManageVO>
//	 * @exception Exception
//	 */
//	public List<LoginPolicyManageVO> selectLoginPolicyAllList(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
//    	return loginPolicyManageDAO.selectLoginPolicyAllList(loginPolicyManageVO);
//    }
}
