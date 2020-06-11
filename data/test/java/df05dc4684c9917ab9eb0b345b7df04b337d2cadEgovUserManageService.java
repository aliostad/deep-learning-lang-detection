package egovframework.bopr.uam.service;

import java.util.List;

/**
 * 사용자관리에 관한 서비스 인터페이스 클래스
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

public interface EgovUserManageService {
	
    /**
	 * 모든 사용자를 조회
	 * @param userManageVO UserManageVO
	 * @return List<UserManageVO>
	 * @exception Exception
	 */
	public List<UserManageVO> selectUserList(UserManageVO userManageVO) throws Exception;
	
	/**
	 * 사용자를 등록
	 * @param userManage UserManage
	 * @exception Exception
	 */
	public void insertUser(UserManage userManage) throws Exception;
	
	/**
	 * 사용자를 수정
 	 * @param userManage UserManage
	 * @exception Exception
	 */
	public void updateUser(UserManage userManage) throws Exception;
	
	/**
	 * 사용자를 삭제
	 * @param userManage UserManage
	 * @exception Exception
	 */
	public void deleteUser(UserManage userManage) throws Exception;

	/**
	 * 목록조회 카운트를 반환한다
	 * @param userManageVO UserManageVO
	 * @return int
	 * @exception Exception
	 */
	public int selectUserListTotCnt(UserManageVO userManageVO) throws Exception;	
	
	/**
	 * 개별 사용자 조회
	 * @param userManageVO UserManageVO
	 * @exception Exception
	 */
	public UserManageVO selectUser(UserManageVO userManageVO) throws Exception;
	
	/**
	 * 입력한 사용자아이디의 중복여부를 체크하여 사용가능여부를 확인
	 * @param checkId 중복여부 확인대상 아이디
	 * @return 사용가능여부(아이디 사용회수 int)
	 * @throws Exception
	 */
	public int checkIdDplct(String checkId) throws Exception;
	
    /**
     * 입력한 사용자의 비밀번호가 맞는지 확인하여 수정가능 하도록 함
     * @param userManage UserManage
     * @return int 수정가능여부(비밀번호가 맞는지 여부)
     */
    public int checkPassword(UserManage userManage)throws Exception;
    
    /**
	 * 비밀번호를 수정
	 * @param userManage UserManage
	 * @exception Exception
	 */
    public void updatePassword(UserManage userManage) throws Exception;

}
