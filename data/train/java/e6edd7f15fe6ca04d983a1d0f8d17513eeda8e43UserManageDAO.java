package lcn.module.batch.web.common.com.dao;

import java.util.List;

import lcn.module.batch.web.common.com.model.UserManage;
import lcn.module.batch.web.common.com.model.UserManageVO;
import lcn.module.framework.base.AbstractDAO;

import org.springframework.stereotype.Repository;

 
/**
 * 사용자관리에 대한 DAO 클래스
 * @user 배치운영환경 김지완
 * @since 2012.07.12
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2012.07.12  김지완          최초 생성
 *
 * </pre>
 */

@Repository("userManageDAO")
public class UserManageDAO extends AbstractDAO {
	
	 /**
	 * 모든 사용자를 조회한다.
	 * @param userManageVO UserManageVO
	 * @return List<UserManageVO>
	 * @exception Exception
	 */
    @SuppressWarnings("unchecked")
	public List<UserManageVO> selectUserList(UserManageVO userManageVO) throws Exception {
        return list("userManageDAO.selectUserAllList", userManageVO);
    }    

	/**
	 * 사용자를 등록
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void insertUser(UserManage userManage) throws Exception {
        insert("userManageDAO.insertUser", userManage);
    }

    /**
	 * 사용자를 수정
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void updateUser(UserManage userManage) throws Exception {
        update("userManageDAO.updateUser", userManage);
    }

    /**
	 * 사용자를 삭제
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void deleteUser(UserManage userManage) throws Exception {
        delete("userManageDAO.deleteUser", userManage);
    }
    
    /**
	 * 사용자목록 총 갯수 조회
	 * @param userManageVO UserManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectUserListTotCnt(UserManageVO userManageVO)  throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("userManageDAO.selectUserListTotCnt", userManageVO);
    }
    
    /**
	 * 사용자를 조회한다.
	 * @param userManageVO UserManageVO
	 * @return UserManageVO
	 * @exception Exception
	 */
    public UserManageVO selectUser(UserManageVO userManageVO) throws Exception {
        return (UserManageVO) selectByPk("userManageDAO.selectUser", userManageVO);
    }
    
    /**
     * 입력한 사용자아이디의 중복여부를 체크하여 사용가능여부를 확인
     * @param checkId 중복체크대상 아이디
     * @return int 사용가능여부(아이디 사용회수 )
     */
    public int checkIdDplct(String checkId){
        return (Integer)getSqlMapClientTemplate().queryForObject("userManageDAO.checkIdDplct_S", checkId);
    }
    
    /**
     * 입력한 사용자의 비밀번호가 맞는지 확인하여 수정가능 하도록 함
     * @param checkPassword 체크대상의 비밀번호
     * @return int 수정가능여부(비밀번호가 맞는지 여부)
     */
    public int checkPassword(UserManage userManage){
        return (Integer)getSqlMapClientTemplate().queryForObject("userManageDAO.checkPassword", userManage);
    }
    
    /**
	 * 비밀번호를 수정
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void updatePassword(UserManage userManage) throws Exception {
        update("userManageDAO.updatePassword", userManage);
    }
}
