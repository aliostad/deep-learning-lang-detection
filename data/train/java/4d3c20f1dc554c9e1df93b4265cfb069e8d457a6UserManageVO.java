package lcn.module.batch.web.common.com.model;

import java.util.List;

/**
 * 사용자관리에 대한 Vo 클래스
 * @author 배치운영환경 김지완
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

public class UserManageVO extends  UserManage{

	private static final long serialVersionUID = 1L;

	List <UserManageVO> userManageList;

	/**
	 * UserManage 를 리턴한다.
	 * @return UserManage
	 */
	public UserManage getUserManage()
    {
    	return getUserManage();
    }
	/**
	 * UserManage 값을 설정한다.
	 * @param userManage UserManage
	 */	
    public void setUserManage(UserManage userManage)
    {
    	setUserManage(userManage);
    }

	/**
	 * userManageList attribute 를 리턴한다.
	 * @return List<UserManageVO>
	 */
	public List<UserManageVO> getUserManageList() {
		return userManageList;
	}

	/**
	 * userManageList attribute 값을 설정한다.
	 * @param userManageList List<UserManageVO> 
	 */
	public void setUserManageList(List<UserManageVO> userManageList) {
		this.userManageList = userManageList;
	}



}