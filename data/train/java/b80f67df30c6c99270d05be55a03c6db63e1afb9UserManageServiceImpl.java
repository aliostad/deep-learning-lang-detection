package lcn.module.batch.web.common.com.service.impl;

import java.util.List;

import javax.annotation.Resource;

import lcn.module.batch.web.common.com.dao.UserManageDAO;
import lcn.module.batch.web.common.com.model.UserManage;
import lcn.module.batch.web.common.com.model.UserManageVO;
import lcn.module.batch.web.common.com.service.UserManageService;
import lcn.module.framework.base.AbstractServiceImpl;

import org.springframework.stereotype.Service;


/**
 * 사용자관리에 관한 ServiceImpl 클래스
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

@Service("userManageService")
public class UserManageServiceImpl extends AbstractServiceImpl implements UserManageService {
    
	@Resource(name="userManageDAO")
    private UserManageDAO userManageDAO;

    /**
	 * 사용자 목록을 조회한다.
	 * @param userManageVO UserManageVO
	 * @return List<UserManageVO>
	 * @exception Exception
	 */
    public List<UserManageVO> selectUserList(UserManageVO userManageVO) throws Exception {
        return userManageDAO.selectUserList(userManageVO);
    }
    
	/**
	 * 사용자를 등록한다.
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void insertUser(UserManage userManage) throws Exception {
    	userManageDAO.insertUser(userManage);
    }

    /**
	 * 사용자를 수정한다.
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void updateUser(UserManage userManage) throws Exception {
    	userManageDAO.updateUser(userManage);
    }

    /**
	 * 사용자를 삭제한다.
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void deleteUser(UserManage userManage) throws Exception {
    	userManageDAO.deleteUser(userManage);
    }

    /**
	 * 사용자 목록 카운트를 조회한다.
	 * @param userManageVO UserManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectUserListTotCnt(UserManageVO userManageVO) throws Exception {
        return userManageDAO.selectUserListTotCnt(userManageVO);
    }

    /**
	 * 권한을 조회한다.
	 * @param userManageVO UserManageVO
	 * @return UserManageVO
	 * @exception Exception
	 */
    public UserManageVO selectUser(UserManageVO userManageVO) throws Exception {
    	UserManageVO resultVO = userManageDAO.selectUser(userManageVO);
        if (resultVO == null){
        	throw processException("info.nodata.msg");
        }
            
        return resultVO;
    }
    
	/**
	 * 입력한 사용자아이디의 중복여부를 체크하여 사용가능여부를 확인
	 * @param checkId 중복여부 확인대상 아이디
	 * @return 사용가능여부(아이디 사용회수 int)
	 * @throws Exception
	 */
	public int checkIdDplct(String checkId) {
		return userManageDAO.checkIdDplct(checkId);
	}
	
    /**
     * 입력한 사용자의 비밀번호가 맞는지 확인하여 수정가능 하도록 함
     * @param userManage UserManage
     * @return int 수정가능여부(비밀번호가 맞는지 여부)
     */
    public int checkPassword(UserManage userManage){
        return userManageDAO.checkPassword(userManage);
    }
    
    /**
	 * 비밀번호를 수정
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void updatePassword(UserManage userManage) throws Exception {
    	userManageDAO.updatePassword(userManage);
    }
}
