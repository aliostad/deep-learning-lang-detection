package lcn.module.batch.web.common.com.dao;

import java.util.List;

import lcn.module.batch.web.common.com.model.LoginPolicyManage;
import lcn.module.batch.web.common.com.model.LoginPolicyManageVO;
import lcn.module.framework.base.AbstractDAO;

import org.springframework.stereotype.Repository;

 
/**
 * 로그인정책관리에 대한 DAO 클래스
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

@Repository("loginPolicyManageDAO")
public class LoginPolicyManageDAO extends AbstractDAO {
	
	 /**
	 * 모든 사용자에 대한 로그인 정책 조회
	 * @param loginPolicyManageVO LoginPolicyManageVO
	 * @return List<LoginPolicyManageVO>
	 * @exception Exception
	 */
    @SuppressWarnings("unchecked")
	public List<LoginPolicyManageVO> selectLoginPolicyList(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
        return list("loginPolicyManageDAO.selectLoginPolicyList", loginPolicyManageVO);
    }    

	/**
	 * 사용자에 대한 로그인 정책 등록
	 * @param loginPolicyManage LoginPolicyManage
	 * @exception Exception
	 */
    public void insertLoginPolicy(LoginPolicyManage loginPolicyManage) throws Exception {
        insert("loginPolicyManageDAO.insertLoginPolicy", loginPolicyManage);
    }

    /**
	 * 사용자에 대한 로그인 정책 수정
	 * @param loginPolicyManage LoginPolicyManage
	 * @exception Exception
	 */
    public void updateLoginPolicy(LoginPolicyManage loginPolicyManage) throws Exception {
        update("loginPolicyManageDAO.updateLoginPolicy", loginPolicyManage);
    }

    /**
	 * 사용자에 대한 로그인 정책 삭제
	 * @param loginPolicyManage LoginPolicyManage
	 * @exception Exception
	 */
    public void deleteLoginPolicy(LoginPolicyManage loginPolicyManage) throws Exception {
        delete("loginPolicyManageDAO.deleteLoginPolicy", loginPolicyManage);
    }
    
    /**
	 * 로그인 정책목록 총 갯수 조회
	 * @param loginPolicyManageVO LoginPolicyManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectLoginPolicyListTotCnt(LoginPolicyManageVO loginPolicyManageVO)  throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("loginPolicyManageDAO.selectLoginPolicyListTotCnt", loginPolicyManageVO);
    }
    
    /**
	 * 로그인 정책 조회한다.
	 * @param loginPolicyManageVO LoginPolicyManageVO
	 * @return LoginPolicyManageVO
	 * @exception Exception
	 */
    public LoginPolicyManageVO selectLoginPolicy(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
        return (LoginPolicyManageVO) selectByPk("loginPolicyManageDAO.selectLoginPolicy", loginPolicyManageVO);
    }
//    
//    /**
//	 * 사용자목록을 조회한다.
//	 * @param loginPolicyManageVO  LoginPolicyManageVO
//	 * @return List<LoginPolicyManageVO>
//	 * @exception Exception
//	 */
//    @SuppressWarnings("unchecked")
//	public List<LoginPolicyManageVO> selectLoginPolicyList(LoginPolicyManageVO loginPolicyManageVO) throws Exception {
//        return list("loginPolicyManageDAO.selectLoginPolicyList", loginPolicyManageVO);
//    }
}
