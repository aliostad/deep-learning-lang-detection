package egovframework.bopr.uam.service;

import java.util.List;

/**
 * 로그인정책관리에 대한 Vo 클래스
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

public class LoginPolicyManageVO extends LoginPolicyManage {

	private static final long serialVersionUID = 1L;

	List <LoginPolicyManageVO> loginPolicyManageList;

	/**
	 * LoginPolicyManage 를 리턴한다.
	 * @return LoginPolicyManage
	 */
	public LoginPolicyManage getLoginPolicyManage()
    {
    	return getLoginPolicyManage();
    }
	/**
	 * LoginPolicyManage 값을 설정한다.
	 * @param loginPolicyManage LoginPolicyManage
	 */	
    public void setLoginPolicyManage(LoginPolicyManage loginPolicyManage)
    {
    	setLoginPolicyManage(loginPolicyManage);
    }

	/**
	 * loginPolicyManageList attribute 를 리턴한다.
	 * @return List<LoginPolicyManageVO>
	 */
	public List<LoginPolicyManageVO> getLoginPolicyManageList() {
		return loginPolicyManageList;
	}

	/**
	 * loginPolicyManageList attribute 값을 설정한다.
	 * @param loginPolicyManageList List<LoginPolicyManageVO> 
	 */
	public void setLoginPolicyManageList(List<LoginPolicyManageVO> loginPolicyManageList) {
		this.loginPolicyManageList = loginPolicyManageList;
	}



}